# Lessons Learned: CMD Script CI/CD and Testing

This document records the key lessons learned during the initial setup of the automated testing framework for the `Helpdesk-Tools.cmd` project. Adhering to these principles is critical for maintaining a stable CI/CD pipeline and ensuring code quality.

## 1. The "Dispatcher" Pattern is Mandatory for Testable Functions

- **Lesson:** The `call script.cmd :label` syntax is unreliable and should **never** be used. It often results in the entire script being executed from the top, which will cause tests to fail or hang if the script contains interactive commands.
- **Principle:** Any function (label) within a `.cmd` script that needs to be tested in isolation **must** be exposed through a dispatcher block at the top of the script.
- **Example Implementation:**
  ```batch
  @echo off

  :: TEST DISPATCHER
  if /i "%~1"=="functionA" goto :functionA
  if /i "%~1"=="functionB" goto :functionB
  if not "%~1"=="" goto :eof :: Exit if called with an unknown function

  :: --- Regular script execution starts here ---
  ```

## 2. `goto :eof` is for Returning; `exit /b` is for Terminating

- **Lesson:** Using `exit /b` inside a function will terminate the entire `cmd.exe` process that is running the script. If called from a test script, control will **not** return to the caller, causing the test runner to fail or report incorrect results.
- **Principle:** To return from a subroutine and give control back to the calling script, always use `goto :eof`. The `ERRORLEVEL` from the last command executed before `goto :eof` will be correctly passed back to the caller.

## 3. Isolate and Simplify to Debug

- **Lesson:** When faced with a persistent, inexplicable error (like the repeated `The syntax of the command is incorrect`), stop guessing and start isolating. Modifying the main codebase repeatedly for debugging is inefficient and risky.
- **Principle:** Create a minimal, temporary test case (a "hello world" version) that isolates the single, most fundamental operation you are trying to perform. If the minimal test passes, the problem is in the code you removed. If it fails, the problem is in the fundamental operation itself. This provides clear, evidence-based direction.

## 4. Consistent Pathing is Critical

- **Lesson:** The CI environment can be sensitive to pathing. The `cd` command inside a test script can alter the relative path resolution for subsequent `call` commands, leading to "file not found" errors.
- **Principle:** Establish a stable working directory in the main test runner (e.g., `cd /d "%~dp0"` in `test_runner.cmd`). All `call` commands in sub-test-scripts should use paths relative to that stable directory, and should not change the directory themselves.

## 5. Acknowledge and Fix Broken Tests

- **Lesson:** A test that "passes" but contains errors in its log (e.g., "command not recognized") is a **failed test**. The test's validation mechanism itself was broken.
- **Principle:** Always inspect the logs of a "successful" run to ensure the tests are passing for the right reasons. A broken assertion is as bad as a failing test.

## 6. Persistent CI Failure: Workflow Execution Context

- **Problem:** The GitHub Actions workflow (`windows-tests.yml`) is consistently failing immediately (0s run, "log not found"), even when the `run:` command is simplified to a basic `echo` or creating/calling a temporary batch file.
- **Debugging Steps Taken:**
    - Simplified `test_runner.cmd` to "hello world".
    - Simplified `windows-tests.yml` to run `echo` directly.
    - Modified `windows-tests.yml` to create and run a temporary batch file with `echo`.
- **Current Hypothesis:** The issue is not with the batch scripts themselves, but with how GitHub Actions' `cmd` shell context executes commands within the `run:` block, or a very subtle YAML syntax error preventing job initiation.
- **Next Debugging Step (for next session):** Try changing the `shell:` from `cmd` to `powershell` in the workflow, or execute a single-line batch command directly in the `run:` block without any `cd` or `call` commands.

## 7. CMD Scripts Can Only Be Tested on a Windows Environment

- **Lesson:** Attempting to execute CMD test runners (e.g., `test_runner.cmd`) on a non-Windows host (like macOS or Linux) is a fundamental error and will always fail. The execution environment must be compatible with the script type.
- **Principle:** All verification for CMD scripts **must** be deferred to the CI pipeline (GitHub Actions), which is correctly configured to use a `windows-latest` runner.
- **Correct Workflow:** The agent's workflow on a non-Windows host is to (1) write the code, (2) write the corresponding test, (3) commit the changes, and (4) push the changes to trigger the CI pipeline. The test results must then be checked via the CI logs, not by local execution.

## 8. Tailor Testing Strategy to Branch Scope

- **Lesson:** The testing strategy must be appropriate for the scope of the work in the current branch. A one-size-fits-all approach is inefficient.
- **Principle 1 (Refactoring Branches):** For branches focused purely on renaming and restructuring (like `refactor/structure-and-naming`), the primary risk is breaking the script's control flow. Detailed unit tests that check for functional side effects are out of scope. The correct strategy is to use efficient "reachability" tests (e.g., loop tests) to verify that all renamed labels are still callable.
- **Principle 2 (Feature/Bugfix Branches):** For branches that add new features or modify the internal logic of a function, detailed **Unit Tests** that verify the specific inputs, outputs, and side effects of that function are mandatory.