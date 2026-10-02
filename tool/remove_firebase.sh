#!/usr/bin/env bash
# Strip Firebase (FCM) from a project generated from this boilerplate.
# Idempotent: safe to run twice. Keeps lib/integrations/local_notifications.
#
#   ./tool/remove_firebase.sh
set -euo pipefail

cd "$(dirname "$0")/.."

LOCATOR="lib/core/di/locator.dart"
APP_GRADLE="android/app/build.gradle.kts"
SETTINGS_GRADLE="android/settings.gradle.kts"
MANIFEST="android/app/src/main/AndroidManifest.xml"

# BSD (macOS) and GNU sed differ on -i; use a temp file instead.
sedi() { local f="$1"; shift; sed "$@" "$f" > "$f.tmp" && mv "$f.tmp" "$f"; }

step() { printf '\n\033[1m• %s\033[0m\n' "$*"; }

step "lib/integrations/firebase/"
rm -rf lib/integrations/firebase

step "pubspec.yaml: drop firebase_core / firebase_messaging"
sedi pubspec.yaml -e '/^  firebase_core:/d' -e '/^  firebase_messaging:/d'

step "$LOCATOR: Firebase → NoopPushService"
sedi "$LOCATOR" -e '/integrations\/firebase\/firebase_di.dart/d'
if grep -q 'registerFirebase(sl);' "$LOCATOR"; then
  sedi "$LOCATOR" \
    -e 's|^\( *\)registerFirebase(sl);.*|\1sl.registerLazySingleton<PushService>(NoopPushService.new);|'
fi
if ! grep -q "push/noop_push_service.dart" "$LOCATOR"; then
  # Insert both push imports right after the dio_builder import (keeps order).
  sedi "$LOCATOR" -e "/^import '..\/network\/dio_builder.dart';/a\\
import '../push/noop_push_service.dart';\\
import '../push/push_service.dart';"
fi

step "Gradle + manifest: remove google-services plugin and FCM meta-data"
sedi "$SETTINGS_GRADLE" -e '/com.google.gms.google-services/d'
sedi "$APP_GRADLE" -e '/firebase:start/,/firebase:end/d'
sedi "$MANIFEST" -e '/firebase:start/,/firebase:end/d'

step "Native config files"
rm -f android/app/google-services.json ios/Runner/GoogleService-Info.plist ios/firebase_app_id_file.json

step "flutter pub get"
if command -v fvm >/dev/null 2>&1; then fvm flutter pub get; else flutter pub get; fi

cat <<'EOF'

Done. Remaining manual steps:
  [ ] Xcode → Runner → Signing & Capabilities: remove "Push Notifications"
      (and "Background Modes → Remote notifications" if unused).
  [ ] ios/Runner/Info.plist: drop UIBackgroundModes/remote-notification if unused.
  [ ] Firebase console: delete the app / revoke the APNs key.
  [ ] README.md: remove the Firebase section.
  [ ] Run `make analyze` and commit.
EOF
