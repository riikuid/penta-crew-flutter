# Firebase push module

Optional. This folder is the **only** place allowed to import `firebase_*`.
The app depends on `PushService` (`lib/core/push/`); `FirebasePushService` is
one implementation, `NoopPushService` is the other.

```
integrations/
├── firebase/
│   ├── firebase_push_service.dart   PushService via FCM (+ background handler)
│   ├── firebase_options.dart        PLACEHOLDER — overwrite with flutterfire configure
│   ├── firebase_di.dart             registerFirebase(sl)
│   └── README.md
└── local_notifications/             independent of Firebase; also shows
    ├── local_notification_service.dart   foreground FCM messages on Android
    └── local_notifications_di.dart
```

Startup: `FirebasePushService.init()` first checks `firebaseIsConfigured()` —
while `firebase_options.dart` is still the placeholder it logs a warning and
skips `Firebase.initializeApp` entirely (local notifications still start).
This check cannot be replaced by a try/catch: the iOS SDK validates the API key
natively and throws an `NSException`, which kills the process before Dart sees
it. `main.dart` additionally wraps `init()` in a try/catch for runtime errors
once Firebase *is* configured (e.g. a stale `GoogleService-Info.plist`).

## Enable

1. **Firebase project + config files**
   ```sh
   dart pub global activate flutterfire_cli
   flutterfire configure --out=lib/integrations/firebase/firebase_options.dart
   ```
   This writes `firebase_options.dart`, `android/app/google-services.json` and
   `ios/Runner/GoogleService-Info.plist`. The last two are gitignored — every
   developer/CI needs their own copy (or inject them in the pipeline).

2. **Android** — nothing else. `android/app/build.gradle.kts` applies the
   `com.google.gms.google-services` plugin automatically when
   `google-services.json` exists; the manifest already declares
   `POST_NOTIFICATIONS` and the `default` channel. The notification channel
   id in the manifest must match `LocalNotificationService.channelId`.

3. **iOS** (cannot be scripted)
   - Xcode → Runner → Signing & Capabilities → `+ Capability`:
     **Push Notifications** and **Background Modes → Remote notifications**
     (`UIBackgroundModes` is already in `Info.plist`).
   - Firebase console → Project settings → Cloud Messaging → upload the
     **APNs authentication key** (.p8) from the Apple Developer portal.
   - Add `GoogleService-Info.plist` to the Runner target in Xcode (drag it in
     with "Copy items if needed" so it ends up in the bundle).

4. **In the app**
   - `locator.dart` already calls `registerLocalNotifications(sl)` and
     `registerFirebase(sl)`.
   - Ask for permission at a sensible moment, not at startup:
     `await sl<PushService>().requestPermission();`
   - Send the token to the backend after login (`Login` usecase already reads
     `getToken()`), and re-send it on `onTokenRefresh`.
   - Navigate on tap: listen to `sl<PushService>().onMessageOpened` (e.g. in
     `App` or a small `PushListener` widget) and route by `message.data`.

### Test from the console
Firebase console → Messaging → *New campaign* → send a test message to the
token printed by `getToken()`. Foreground on Android is displayed through
`LocalNotificationService`; background/terminated is displayed by the OS.

### Known upstream warning
On Flutter 3.47 the build prints a warning that `firebase_core` still applies
the Kotlin Gradle Plugin itself. It is harmless and comes from the plugin,
not from this project.

## Remove

```sh
./tool/remove_firebase.sh
```

The script deletes this folder, drops `firebase_core`/`firebase_messaging`
from `pubspec.yaml`, switches `locator.dart` to `NoopPushService`, removes the
Gradle plugin lines and the manifest meta-data (everything between
`firebase:start` / `firebase:end` markers), deletes the native config files,
and runs `pub get`. It prints the manual leftovers (Xcode capability, Firebase
console). `local_notifications` is kept — delete that folder too if unused.
