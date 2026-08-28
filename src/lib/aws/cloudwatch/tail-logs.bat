@echo off

if "%~2"=="" (
    echo Usage:
    echo tail_logs.bat LOG_GROUP LOG_STREAM [REGION]
    exit /b 1
)

set LOG_GROUP=%~1
set LOG_STREAM=%~2
set REGION=%~3

if "%REGION%"=="" set REGION=us-east-1

aws logs tail "%LOG_GROUP%" ^
  --region "%REGION%" ^
  --follow ^
  --log-stream-names "%LOG_STREAM%"


if errorlevel 1 (
    echo.
    echo Command failed with error code %ERRORLEVEL%.
    pause
)