<!-- markdownlint-disable -->

# Hardening Report: FirebaseExtended--github-actions--firebase-test-lab/v1.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **FirebaseExtended--github-actions--firebase-test-lab/v1.3** was hardened automatically. 12 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Composite action steps point to tags instead of full commit SHAs: `uses: 'google-github-actions/auth@v0'` (line 69) and `uses: google-github-actions/setup-gcloud@v0` (line 75).

Locations:

- `action.yml:69`
- `action.yml:75`

### script-injection (severity: high)

Rule (a): the ftl_test run block puts expressions straight into the shell command: `test_result=$(python $GITHUB_ACTION_PATH/trigger_ftl_tests.py --arg_groups="${{ inputs.arg_groups }}" --testapp_dir="${{ inputs.testapp_dir }}" --test_type="${{ inputs.test_type }}" --timeout="${{ inputs.timeout }}" --test_devices="${{ inputs.test_devices }}" --test_device_selection="${{ inputs.test_device_selection }}" --additional_flags="${{ inputs.additional_flags }}" --max_attempts="${{ inputs.max_attempts }}" --validator="${{ inputs.validator }}")`. Rule (b): several expansions are unquoted, including `$GITHUB_ACTION_PATH`, `${test_result}` in `[[ ! -z ${test_result} ]]`, `echo ${test_result:2}` and `echo ${test_result:0:1}`.

Locations:

- `action.yml:82`

### github-env-injection (severity: high)

The ftl_test step writes `echo "test_summary=$(echo ${test_result:2})" >> $GITHUB_OUTPUT`. test_result is the output of a script that receives untrusted inputs.* values, such as arg_groups, testapp_dir and additional_flags. Newlines are not removed with `printf '%s' ... | tr -d '\n\r'` before the write, so extra output lines can be injected.

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

Pinned google-github-actions/auth@v0 to 09cecabe1f169596b81c2ef22b40faff87acc460 and setup-gcloud@v0 to 20c93dacc1d70ddbce76c63ab32c35595345bdd1. Moved every inputs.* expression in the ftl_test step into env vars (INPUT_*) and referenced them double-quoted, quoted $GITHUB_ACTION_PATH and test_result expansions. The test_summary value now goes through printf | tr -d '\n\r' before it's written to $GITHUB_OUTPUT. trigger_ftl_tests.py prints a single line, so the output value is unchanged. The exit-code logic is the same as before.

### Iteration 2

**Fixes applied:** unpinned-uses

**Notes:**

Rebuilt the damaged steps in action.yml. The auth step has its `service_account` input back. The setup-gcloud step now uses only the SHA-pinned reference, google-github-actions/setup-gcloud@20c93dacc1d70ddbce76c63ab32c35595345bdd1 # v0, and the unpinned @v0 is removed. Two lines were cut off, so I rebuilt them by inference rather than from upstream's text: `install_components: 'beta'` (the script calls `gcloud beta firebase test ios run`) and the `id: ftl_test` step header, which the declared output reads from. I also added `--project_id="$INPUT_PROJECT_ID"` (mapped through env:), because the action declares a project_id input and the script accepts that flag. I haven't checked this against upstream; if the value is empty, the script falls back to GCLOUD_PROJECT. Finally, I removed the leftover `fi})` and the duplicate else/fi lines so the run script parses.

