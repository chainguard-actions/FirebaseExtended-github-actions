<!-- markdownlint-disable -->

# Hardening Report: FirebaseExtended--github-actions--firebase-test-lab/v1.5

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **FirebaseExtended--github-actions--firebase-test-lab/v1.5** was hardened automatically. 11 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a) is violated: the ftl_test step's run: block puts input expressions straight into the shell command, so a crafted input can run arbitrary shell code. The offending line is: test_result=$(python $GITHUB_ACTION_PATH/trigger_ftl_tests.py --arg_groups="${{ inputs.arg_groups }}" --testapp_dir="${{ inputs.testapp_dir }}" --test_type="${{ inputs.test_type }}" --timeout="${{ inputs.timeout }}" --test_devices="${{ inputs.test_devices }}" --test_device_selection="${{ inputs.test_device_selection }}" --additional_flags="${{ inputs.additional_flags }}" --max_attempts="${{ inputs.max_attempts }}" --validator="${{ inputs.validator }}"). Fix: pass each input through the step's env: block and refer to it as a double-quoted shell variable. Also quote "$GITHUB_ACTION_PATH".

Locations:

- `action.yml:82`

### github-env-injection (severity: high)

The ftl_test step writes data derived from inputs to $GITHUB_OUTPUT without the required sanitization. test_result is the output of trigger_ftl_tests.py, which receives the untrusted inputs as arguments, and it is written with: echo "test_summary=$(echo ${test_result:2})" >> $GITHUB_OUTPUT. The required step, printf '%s' ... | tr -d '\n\r', is missing, so an attacker could inject extra output lines.

Locations:

- `action.yml:86`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.arg_groups }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:82`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.testapp_dir }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:82`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.test_type }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:82`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:82`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.test_devices }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:82`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.test_device_selection }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:82`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.additional_flags }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:82`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.max_attempts }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:82`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.validator }}" appears directly in run: block of step ""; move to env: map

Locations:

- `action.yml:82`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, static-inline-injection

**Notes:**

Moved all inputs used in the ftl_test run block into the step's env: and referenced them as double-quoted variables; quoted "$GITHUB_ACTION_PATH". The test summary is computed as upstream did (echo of ${test_result:2}), then stripped of CR/LF with printf|tr before writing to "$GITHUB_OUTPUT".

