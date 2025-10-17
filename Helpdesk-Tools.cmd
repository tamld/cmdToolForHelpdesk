@echo off

:: TEST DISPATCHER
if /i "%~1"=="checkCompatibility" goto :checkCompatibility
goto :eof

:checkCompatibility
echo Reached :checkCompatibility label successfully.
goto :eof
