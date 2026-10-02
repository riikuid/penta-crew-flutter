# penta_crew — Flutter boilerplate

Feature-first Flutter starter for Laravel-style REST backends. Opinionated and
small: one way to do each thing, so a new feature is a copy of `features/sample`.

| | |
|---|---|
| Flutter / Dart | **3.47.6 / 3.13** (pinned with [fvm](https://fvm.app), see `.fvmrc`) |
| State | `flutter_bloc` (Cubit) |
| Navigation | `go_router` 18 |
| HTTP | `dio` + `talker_dio_logger` |
| DI | `get_it` (no codegen) |
| Models / states | `freezed` 4 + `json_serializable` |
| Secure storage | `flutter_secure_storage` |
| Logging | `talker_flutter` |
| Push (optional) | `firebase_messaging` + `flutter_local_notifications` — see [Firebase](#firebase-optional) |

## Getting started

```sh
dart pub global activate fvm      # once per machine
fvm install                       # reads .fvmrc → Flutter 3.47.6
make get                          # fvm flutter pub get
make gen                          # build_runner (freezed/json files are committed; run after model changes)
make run-dev                      # ./tool/run.sh dev
```

VS Code: `.vscode/launch.json` has `dev`, `staging` and `prod (release)`
configurations that pass the right `--dart-define-from-file`.

Other targets: `make watch` (codegen on save), `make analyze`, `make test`,
`make run-staging`, `make build-staging` (apk), `make build-prod` (appbundle).

## Environments

Config is injected **at build time**, never bundled as an asset:

```
env/dev.json          { "FLAVOR": "dev", "APP_NAME": "...", "BASE_URL": "...", "ENABLE_LOGGING": true }
env/staging.json
env/prod.json         gitignored — copy env/prod.example.json
```

`tool/run.sh <env>` / `tool/build.sh <env> <apk|appbundle|ipa>` wrap
`flutter run|build --dart-define-from-file=env/<env>.json`. In code read values
through `Env` (`lib/core/config/env.dart`, `String.fromEnvironment`) — nothing
else reads config. Add a key: `env/*.json` → `Env` constant → done.

## Folder structure

```
lib/
├── main.dart                 setupLocator() → PushService.init() (try/catch) → AuthCubit.checkSession() → runApp
├── app.dart                  MaterialApp.router + the only global BlocProvider (AuthCubit)
├── core/
│   ├── config/               Env (dart-define), AppMessages (fallback copy)
│   ├── di/locator.dart       `sl` + setupLocator(): infra + register<Feature>(sl) calls
│   ├── network/              Result<T>, dioCall(), api_json helpers, Paginated<T>, Dio builder, AuthInterceptor
│   ├── session/              SessionStorage (secure), SessionInfo (router contract), SessionEvents (401 bridge)
│   ├── router/               app_router (assembles feature routes), route_guard, router_refresh, app_routes
│   ├── usecase/              UseCase<R, P> + NoParams
│   ├── push/                 PushService interface + NoopPushService
│   ├── json/                 JsonConverters (DateOnlyConverter, BoolIntConverter, …)
│   ├── logging/              Talker factory + BlocObserver
│   ├── theme/                ThemeData from a ColorScheme
│   └── widgets/              toast, buttons, LoadingView / EmptyView / ErrorView
├── features/
│   ├── auth/                 login, session, splash, forbidden — the only feature with a global cubit
│   ├── home/                 placeholder landing screen
│   └── sample/               ★ template: paginated list + detail (copy this)
│       ├── models/           freezed models (+ generated .freezed.dart / .g.dart)
│       ├── repositories/     pure HTTP, one method per endpoint
│       ├── usecases/         one class per file, params in the same file
│       ├── presentation/     cubit/ (cubit + freezed state) and screens/
│       ├── sample_routes.dart   `List<RouteBase>` + path constants
│       └── sample_di.dart       registerSample(GetIt sl)
└── integrations/
    ├── firebase/             the ONLY folder that imports firebase_*  (removable)
    └── local_notifications/  flutter_local_notifications wrapper (independent of Firebase)
env/                          dart-define files per flavor
tool/                         run.sh, build.sh, remove_firebase.sh
test/                         mirrors lib/ (core/network, core/router, features/*)
```

## Architecture

### The one rule: Cubit → UseCase → Repository

```
Screen ──▶ Cubit ──▶ UseCase ──▶ Repository ──▶ Dio
            │           │
            │           └── side effects live here (save token, register device, …)
            └── emits freezed states; UI pattern-matches with `switch`
```

- **Repository** = pure HTTP. One method per endpoint, returns `Result<T>`, no
  storage, no navigation, no other repositories.
- **UseCase** = one business action, one file, `call(params)`. Params class is
  declared in the same file. Orchestration and side effects go here, so they
  can be reused from a cubit, a background handler, or a test.
- **Cubit** = page state only. Never constructs its dependencies; receives them
  via the constructor from `sl`.
- No exceptions: every network call returns `Result<T>`.

```dart
// repository
Future<Result<Paginated<SampleItem>>> list({required int page, String? search}) => dioCall(
  () => _dio.get('/samples', queryParameters: {'page': page, 'search': ?search}),
  parse: (body) => Paginated.fromJson(body, SampleItem.fromJson),
);

// cubit
switch (await _getList(GetSampleListParams(page: 1))) {
  case Success(:final value): emit(SampleListState.loaded(data: value.data, hasReachedMax: value.isLast));
  case Failed(:final message): emit(SampleListState.error(message: message));
}
```

### `Result<T>` and `dioCall`

`Result<T>` is sealed: `Success(value, statusCode)` or
`Failed(message, statusCode, fieldErrors)`. `dioCall(request, parse:)` turns
every failure mode into a `Failed` with a user-safe message: timeouts,
no connection, non-2xx with a Laravel `{message, errors}` body (422 →
`fieldErrors`), and parser exceptions. `Failed` has `isUnauthorized`,
`isValidation`, `fieldError('email')`. Parse bodies with `asObject` /
`asList` (`lib/core/network/api_json.dart`), which unwrap the `data` envelope.

### Dependency injection

`get_it`, no `injectable`. Two registrations only:

| | `registerLazySingleton` | `registerFactory` |
|---|---|---|
| Use for | Dio, storage, Talker, **repositories** | **usecases**, **page cubits** |
| Lifetime | one instance, created on first `sl<T>()` | new instance every `sl<T>()` |

Page cubits are created **in the route builder** and owned by `BlocProvider`,
so they live exactly as long as the page:

```dart
GoRoute(
  path: SampleRoutes.list,
  redirect: guard(),
  builder: (context, state) => BlocProvider(
    create: (_) => sl<SampleListCubit>()..fetch(),
    child: const SampleListScreen(),
  ),
),
```

`AuthCubit` is the only app-wide cubit (provided in `app.dart`).

### Session flow

1. `main()` calls `AuthCubit.checkSession()`; state is `unknown` while the
   stored token is verified via `GET /me`.
2. The top-level redirect in `app_router.dart` parks every navigation on
   `/` (splash) while `SessionInfo.isResolving`, remembering the target in
   `?from=` — so deep links survive a cold start.
3. Outcome: `authenticated` → go to `from` or home · `unauthenticated` →
   login (also with `from`) · `unavailable` (offline) → splash shows retry,
   token is kept.
4. Any later `401` is seen by `AuthInterceptor`, which emits
   `SessionEvent.unauthorized` on `SessionEvents`. `AuthCubit` listens,
   clears the token once (bursts of 401s are idempotent) and emits
   `unauthenticated(sessionExpired: true)`; `RouterRefresh` makes go_router
   re-evaluate redirects. The network layer never imports UI.

### Route guards

```dart
redirect: guard()                                        // signed in
redirect: guard(perms: ['order.read'])                   // signed in + any of
redirect: guard(perms: ['a', 'b'], mode: PermMode.all)   // signed in + all of
redirect: guard(requireAuth: false)                      // public
redirect: guestOnly()                                    // login/register: bounce signed-in users home
```

Guards read `sl<SessionInfo>()` (implemented by `AuthCubit`) so `core/router`
never imports a feature. Unauthenticated → `/login?from=<uri>`; missing
permission → `/forbidden`.

## Adding a feature in 4 steps

Example: `orders`.

**1. Copy the template**

```sh
cp -r lib/features/sample lib/features/orders
cd lib/features/orders && rm -f **/*.freezed.dart **/*.g.dart
# rename files + identifiers: sample→orders, Sample→Order, SampleItem→Order …
```

Keep the layout: `models/`, `repositories/`, `usecases/`, `presentation/{cubit,screens}/`,
`orders_routes.dart`, `orders_di.dart`.

**2. Register dependencies** — `lib/features/orders/orders_di.dart`

```dart
void registerOrders(GetIt sl) {
  sl.registerLazySingleton(() => OrderRepository(sl()));
  sl.registerFactory(() => GetOrderList(sl()));
  sl.registerFactory(() => OrderListCubit(sl()));
}
```

then one line in `lib/core/di/locator.dart`:

```dart
  registerAuth(sl);
  registerSample(sl);
  registerOrders(sl);   // ← add
```

**3. Declare routes** — `lib/features/orders/orders_routes.dart`

```dart
abstract final class OrderRoutes {
  static const list = '/orders';
  static String detail(int id) => '/orders/$id';
}

final List<RouteBase> orderRoutes = [
  GoRoute(
    path: OrderRoutes.list,
    redirect: guard(perms: ['order.read']),
    builder: (_, __) => BlocProvider(
      create: (_) => sl<OrderListCubit>()..fetch(),
      child: const OrderListScreen(),
    ),
  ),
];
```

then spread them in `lib/core/router/app_router.dart`:

```dart
    routes: [
      ...authRoutes,
      ...homeRoutes,
      ...sampleRoutes,
      ...orderRoutes,   // ← add
    ],
```

**4. Generate and verify**

```sh
make gen && make analyze && make test
```

Navigate with `context.push(OrderRoutes.detail(id))`.

## Codegen (freezed + json_serializable)

```sh
make gen     # once: dart run build_runner build
make watch   # while coding
```

`build.yaml` sets `field_rename: snake` and `explicit_to_json: true` globally,
so `avatarUrl` ↔ `"avatar_url"` without annotations. Generated files are
committed; `analysis_options.yaml` excludes them from lints.

| Symptom | Cause / fix |
|---|---|
| `Target of URI hasn't been generated: 'x.freezed.dart'` | Run `make gen` (or `make watch` is not running). |
| `The getter '_$XFromJson' isn't defined` | Nested model lacks `@freezed` + `fromJson`, or you forgot `part 'x.g.dart';`. |
| Date column round-trips as full ISO timestamp | Annotate with `@DateOnlyConverter()` (`lib/core/json/converters.dart`). |
| `"is_active": 1` into a `bool` | `@BoolIntConverter()`. |
| API key is not snake_case (`"ID"`, `"userName"`) | `@JsonKey(name: 'userName')` — only for non-snake names. |
| Build is slow | `build.yaml` → `generate_for` already limits codegen to `lib/features/**` and `lib/core/**`; keep models there. |
| `--delete-conflicting-outputs: unknown option` | Removed in build_runner 2.16; just `build`. Use `make clean-gen` if outputs conflict. |

## Firebase (optional)

Push is behind the `PushService` interface (`lib/core/push/`). The default
wiring uses Firebase, but **only `lib/integrations/firebase/` imports
`firebase_*`**. Setup, iOS capabilities and removal are documented in
[`lib/integrations/firebase/README.md`](lib/integrations/firebase/README.md).

```sh
./tool/remove_firebase.sh   # strips Firebase; app falls back to NoopPushService
```

A missing `google-services.json` does not break the build (the Gradle plugin
is applied conditionally) and a failing `Firebase.initializeApp` is caught in
`main.dart` — push is simply off. Flutter 3.47 prints an upstream warning that
`firebase_core` still applies the Kotlin Gradle Plugin; harmless.

## Conventions

- `flutter_lints` + a few extras in `analysis_options.yaml`; `make analyze`
  must be clean.
- No `print` / `dev.log` — use `sl<Talker>()`. `TalkerDioLogger` logs HTTP
  outside prod; `AppBlocObserver` logs cubit transitions.
- No class constructs its own dependencies (`= XRepository()` is a review
  blocker). Everything comes from `sl`.
- Repositories never touch storage or UI; cubits never call Dio.
- Features import `core/`; `core/` imports features only in `locator.dart`
  and `app_router.dart`.
- Generated files are committed. `env/prod.json` and the Firebase native
  configs are not.
- Tests: `test/` mirrors `lib/`. Cubits are tested with `bloc_test` +
  `mocktail` against mocked usecases; `dioCall` with a stub
  `HttpClientAdapter` (no sockets, no Firebase).

## Known issues / TODO

- `firebase_options.dart` is a placeholder — run `flutterfire configure`.
- `features/home` is a placeholder screen.
- No `PermissionCubit`: permissions are read from `User.permissions`
  (loaded by `GET /me`). Add a refresh path if your backend changes
  permissions without re-login.
- Theme is a single `ColorScheme`; no dark mode tokens yet.
- Release signing (`android/app/build.gradle.kts`) still uses the debug key.
- App icon / splash: `flutter_launcher_icons` and `flutter_native_splash` are
  in dev deps but not configured.
