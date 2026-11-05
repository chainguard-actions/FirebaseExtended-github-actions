#!/bin/bash
# Prepare the test environment: fake gcloud on PATH, 'python' command,
# and an 'imp' shim when running on Python >= 3.12.
set -euo pipefail
FIX="$GITHUB_WORKSPACE/tests/fixtures"
BIN="${RUNNER_TEMP:-/tmp}/ftl-fakebin"
mkdir -p "$BIN"
cp "$FIX/fakebin/gcloud" "$BIN/gcloud"
chmod +x "$BIN/gcloud"
if ! command -v python >/dev/null 2>&1; then
  ln -sf "$(command -v python3)" "$BIN/python"
fi
echo "$BIN" >> "$GITHUB_PATH"
PY="$(command -v python || command -v python3)"
if ! "$PY" -c "import imp" >/dev/null 2>&1; then
  echo "PYTHONPATH=$FIX/pyshim" >> "$GITHUB_ENV"
fi
rm -f /tmp/fake-gcloud-calls.log
echo "setup done"
