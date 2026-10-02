#!/usr/bin/env bash
# Run the app against one environment.
#   ./tool/run.sh dev            # default
#   ./tool/run.sh staging -d <device-id>
# Extra args are forwarded to `flutter run`.
set -euo pipefail

ENV_NAME="${1:-dev}"
shift || true

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/env/$ENV_NAME.json"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "env file not found: $ENV_FILE" >&2
  echo "available: $(ls "$ROOT/env" | grep -v example | sed 's/\.json//' | tr '\n' ' ')" >&2
  exit 1
fi

FLUTTER="flutter"
command -v fvm >/dev/null 2>&1 && FLUTTER="fvm flutter"

cd "$ROOT"
exec $FLUTTER run --dart-define-from-file="$ENV_FILE" "$@"
