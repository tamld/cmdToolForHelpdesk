# Automated Testing Framework for Helpdesk-Tools

## 1. Overview

This directory contains the automated testing framework for the `Helpdesk-Tools.cmd` script. The primary goal of this framework is to ensure the script's integrity, prevent regressions, and enable safe, rapid refactoring and development.

The testing strategy is formally defined in `../.agents/testing_strategy.yml`.

## 2. How to Run Tests

All tests are executed via the master test runner script.

```batch
:: Navigate to the tests directory
cd /d "%~dp0"

:: Run all tests
call test_runner.cmd
```

The runner will execute all test cases found in the `unit`, `integration`, and `e2e` subdirectories. The final output will show a summary of passed and failed tests.

## 3. Framework Structure

-   `/tests`
    -   `test_runner.cmd`: The master script that discovers and executes all tests.
    -   `test_utils.cmd`: The core utility library containing assertion functions (e.g., `:assertSuccess`, `:assertEqual`).
    -   `README.md`: This file.
    -   `/unit`: Contains unit tests that verify individual functions (`:label`) in isolation.
    -   `/integration`: Contains integration tests that verify the interaction and navigation between different functions and menus.
    -   `/e2e`: Contains end-to-end tests that simulate a full user journey.
    -   `/fixtures`: Contains mock files, sample inputs, and other test data.
    -   `/reports`: Contains detailed log output from test runs.

## 4. Writing a New Test

To add a new test, follow these steps:

1.  **Choose the Right Directory:** Place your test script in the appropriate directory (`unit`, `integration`, or `e2e`) based on the type of test.
2.  **Create the Test File:** Create a new `.cmd` file (e.g., `test_myFunction.cmd`).
3.  **Write the Test Logic:**
    -   Inside your test file, `call` the function from the main `Helpdesk-Tools.cmd` script that you want to test.
    -   After the function call, use the assertion functions from `test_utils.cmd` to check the result (e.g., `call :assertSuccess`, `call :assertEqual %var% "expected_value"`).
    -   A test case passes if it completes without any assertion failures. An assertion failure should terminate the script with a non-zero `ERRORLEVEL`.
4.  **Update the Test Runner:** For now, you may need to manually add a `call` to your new test script in `test_runner.cmd`. (This will be automated later).

## 5. CI/CD Integration

These tests are designed to be run automatically by a GitHub Actions workflow on every push to a development branch. A failing test will block the code from being merged into the `main` branch, ensuring quality and stability.
