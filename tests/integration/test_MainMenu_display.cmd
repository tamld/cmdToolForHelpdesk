@echo off
:: Test: test_MainMenu_display.cmd
:: Goal: Verify that the main menu displays correctly by checking for its title in the script's output.

setlocal

:: Define paths relative to this test script's location
set "TEST_DIR=%~dp0"
set "REPORTS_DIR=%TEST_DIR%..\reports"
set "SCRIPT_PATH=%TEST_DIR%..\..\Helpdesk-Tools.cmd"
set "LOG_FILE=%REPORTS_DIR%\test_MainMenu_display.log"
set "INPUT_FILE=%TEST_DIR%input.txt"

:: Ensure the reports directory exists
if not exist "%REPORTS_DIR%" mkdir "%REPORTS_DIR%"

:: Create a temporary input file to select the 'Exit' option
(echo 7) > "%INPUT_FILE%"

:: Run the main script, redirecting input from the temp file and capturing output
call "%SCRIPT_PATH%" < "%INPUT_FILE%" > "%LOG_FILE%" 2>&1

:: Clean up the temporary input file
del "%INPUT_FILE%"

:: Define the anchor text to search for
set "ANCHOR_TEXT=Install All In One Online"

:: Search for the anchor text in the log file
findstr /C:"%ANCHOR_TEXT%" "%LOG_FILE%" > nul

:: Check the result of findstr and set errorlevel accordingly
if %errorlevel% equ 0 (
    echo [SUCCESS] Main menu display test passed. Anchor text found.
    endlocal
    exit /b 0
) else (
    echo [FAILURE] Main menu display test failed. Anchor text NOT found.
    echo           Check the log file for details: %LOG_FILE%
    endlocal
    exit /b 1
)