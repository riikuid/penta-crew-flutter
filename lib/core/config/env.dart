/// Build-time configuration.
///
/// Values come from `--dart-define-from-file=env/<flavor>.json` (see `tool/run.sh`,
/// `tool/build.sh` and `.vscode/launch.json`). Nothing here is read from an asset,
/// so no config file ends up inside the APK/IPA.
abstract final class Env {
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Penta Crew',
  );

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8000/api',
  );

  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  static bool get isDev => flavor == 'dev';
  static bool get isStaging => flavor == 'staging';
  static bool get isProd => flavor == 'prod';
}
