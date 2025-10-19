@echo off
:: Test: test_MainMenu_display.cmd
:: Goal: Verify that the main menu displays correctly by checking for its title in the script's output.

:: Define the log file path relative to the tests directory.
set "LOG_FILE=%~dp0..\reports\test_MainMenu_display.log"
set "SCRIPT_PATH=%~dp0..\..\Helpdesk-Tools.cmd"

:: Ensure the reports directory exists
if not exist "%~dp0..\reports" mkdir "%~dp0..\reports"

:: Run the main script and capture its output. The 'echo 9' is to select the exit option if available, 
:: or simply to provide some input to prevent the script from hanging indefinitely.
(echo 7) | call "%SCRIPT_PATH%" > "%LOG_FILE%" 2>&1

:: Define the anchor text to search for.
set "ANCHOR_TEXT=Install All In One Online"

:: Search for the anchor text in the log file.
findstr /C:"%ANCHOR_TEXT%" "%LOG_FILE%" > nul

:: Check the result of findstr.
if %errorlevel% equ 0 (
    echo [SUCCESS] Main menu display test passed. Anchor text found.
    exit /b 0
) else (
    echo [FAILURE] Main menu display test failed. Anchor text NOT found.
    echo           Check the log file for details: %LOG_FILE%
    exit /b 1
)
