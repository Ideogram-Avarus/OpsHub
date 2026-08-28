@echo off
setlocal EnableDelayedExpansion

for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$c=Import-PowerShellDataFile '%~dp0..\config\project.config.psd1'; $c.AWS.Lambda.IgualarFunctionName"') do set FUNCTION_NAME=%%i

call "%~dp0..\lib\aws\lambda\invoke.bat" !FUNCTION_NAME! EMPTY RESPONSE_FILE
echo %RESPONSE_FILE%

if errorlevel 1 (
    echo Error encountered.
    exit /b 1
)

echo.
echo ===== Lambda Response =====
type "!RESPONSE_FILE!"
echo.
echo ===========================

del "!RESPONSE_FILE!" >nul 2>&1
