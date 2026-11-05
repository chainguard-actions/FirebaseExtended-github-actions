#!/bin/bash
# Fake gcloud used by the tests: records its arguments and prints output that
# mimics `gcloud firebase test ... run`. Behavior is configured through files:
#   /tmp/fake-gcloud-exit     exit code (default 0)
#   /tmp/fake-gcloud-outcome  outcome string (default Passed)
#   /tmp/fake-gcloud-style    "plain" (default) or "table"
echo "$*" >> /tmp/fake-gcloud-calls.log

exit_code=$(cat /tmp/fake-gcloud-exit 2>/dev/null || echo 0)
outcome=$(cat /tmp/fake-gcloud-outcome 2>/dev/null || echo Passed)
style=$(cat /tmp/fake-gcloud-style 2>/dev/null || echo plain)

app=""
prev=""
for a in "$@"; do
  case "$prev" in
    --app) app="$a" ;;
    --test) [ -z "$app" ] && app="$a" ;;
  esac
  prev="$a"
done

echo "Uploading [$app] to Firebase Test Lab..."
echo "Raw results will be stored in your GCS bucket at [https://console.developers.google.com/storage/browser/fake-bucket/]"
echo ""
echo "Test results will be streamed to [https://console.firebase.google.com/project/fake-project/testlab/histories/h1/matrices/m1]."

if [ "$style" = "table" ]; then
  echo "┌─────────┬──────────────────────────────┬─────────────────────┐"
  echo "│ OUTCOME │       TEST_AXIS_VALUE        │     TEST_DETAILS    │"
  echo "├─────────┼──────────────────────────────┼─────────────────────┤"
  echo "│ $outcome  │ fake-device-en-portrait │ -- │"
  echo "└─────────┴──────────────────────────────┴─────────────────────┘"
else
  printf 'OUTCOME: %s\nTEST_AXIS_VALUE: fake-device-en-portrait\nTEST_DETAILS: --\n' "$outcome"
fi

exit "$exit_code"
