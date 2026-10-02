#!/usr/bin/env bash
# Build a release artifact for one environment.
#   ./tool/build.sh prod apk
#   ./tool/build.sh staging appbundle
#   ./tool/build.sh prod ipa
# Extra args are forwarded to `flutter build`.
set -euo pipefail

ENV_NAME="${1:-prod}"
TARGET="${2:-apk}"
shift 2 || shift || true

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/env/$ENV_NAME.json"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "env file not found: $ENV_FILE" >&2
  if [[ "$ENV_NAME" == "prod" ]]; then
    echo "copy env/prod.example.json to env/prod.json and fill in the real values." >&2
  fi
  exit 1
fi

FLUTTER="flutter"
command -v fvm >/dev/null 2>&1 && FLUTTER="fvm flutter"

cd "$ROOT"
exec $FLUTTER build "$TARGET" --release --dart-define-from-file="$ENV_FILE" "$@"
