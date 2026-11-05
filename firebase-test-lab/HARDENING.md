<!-- markdownlint-disable -->

# Hardening Report: FirebaseExtended--github-actions--firebase-test-lab/v1.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **FirebaseExtended--github-actions--firebase-test-lab/v1.4** was hardened automatically. 12 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Two composite steps reference actions by tag instead of by a full 40-character commit SHA: 'uses: google-github-actions/auth@v2' (line 69) and 'uses: google-github-actions/setup-gcloud@v1' (line 75).

Locations:

- `action.yml:69`
- `action.yml:75`

### script-injection (severity: high)

Rule (a): step 'ftl_test' places inputs.arg_groups, inputs.testapp_dir, inputs.test_type, inputs.timeout, inputs.test_devices, inputs.test_device_selection, inputs.additional_flags, inputs.max_attempts and inputs.validator directly into the run: script as ${{ }} expressions. Offending line: test_result=$(python $GITHUB_ACTION_PATH/trigger_ftl_tests.py --arg_groups="${{ inputs.arg_groups }}" ... --validator="${{ inputs.validator }}"). Rule (b): ${test_result} is also expanded without quotes in '[[ ! -z ${test_result} ]]', 'echo ${test_result:2}' and 'exit $(echo ${test_result:0:1})'.

Locations:

- `action.yml:82`
- `action.yml:86`

### github-env-injection (severity: high)

Step 'ftl_test' writes 'echo "test_summary=$(echo ${test_result:2})" >> $GITHUB_OUTPUT'. test_result is the output of a script that receives untrusted inputs (arg_groups, testapp_dir, additional_flags, validator, etc.). The value is written without the printf '%s' ... | tr -d '\n\r' sanitization, so newlines in it could inject extra outputs.

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

**Fixes applied:** unpinned-uses, script-injection, github-env-injection, static-inline-injection

**Notes:**

Pinned google-github-actions/auth@v2 and setup-gcloud@v1 to full SHAs. Moved all inputs used in the ftl_test step into env: vars and referenced them double-quoted. Quoted $GITHUB_ACTION_PATH and test_result expansions. test_summary is now built by whitespace-splitting the result into an array and joining it with spaces (same as upstream's unquoted echo, but without globbing), then has newlines stripped before it is written to $GITHUB_OUTPUT. Exit code is now 'exit "${test_result:0:1}"'.

