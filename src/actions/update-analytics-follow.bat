@echo off
setlocal EnableDelayedExpansion

for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$c=Import-PowerShellDataFile '%~dp0..\config\project.config.psd1'; $c.AWS.Batch.AnalyticsJobName"') do set JOB_NAME=%%i
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$c=Import-PowerShellDataFile '%~dp0..\config\project.config.psd1'; $c.AWS.Batch.AnalyticsJobQueue"') do set JOB_QUEUE=%%i
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$c=Import-PowerShellDataFile '%~dp0..\config\project.config.psd1'; $c.AWS.Batch.AnalyticsJobDefinition"') do set JOB_DEFINITION=%%i

echo Submitting job...

for /f "tokens=*" %%i in ('
  aws batch submit-job ^
    --job-name "%JOB_NAME%" ^
    --job-queue "%JOB_QUEUE%" ^
    --job-definition "%JOB_DEFINITION%" ^
    --query jobId ^
    --output text
') do (
  set JOB_ID=%%i
)

echo Job submitted: !JOB_ID!


call "%~dp0..\lib\aws\batch\status.bat" !JOB_ID! STATUS

:wait_for_log_stream

call "%~dp0..\lib\aws\batch\logs.bat" !JOB_ID! LOG_GROUP LOG_STREAM

if /I "!LOG_STREAM!"=="None" (
    echo Waiting for log stream...
    timeout /t 3 >nul
    goto wait_for_log_stream
)

:wait_loop
call "%~dp0..\lib\aws\batch\status.bat" !JOB_ID! STATUS
if "%STATUS%"=="RUNNING" goto get_logs
if "%STATUS%"=="FAILED" goto end
if "%STATUS%"=="SUCCEEDED" goto end

echo Waiting for status: !STATUS!
timeout /t 5 >nul
goto wait_loop


:get_logs
powershell -ExecutionPolicy Bypass ^
    -File "%~dp0/..\lib\aws/batch/monitor-batch-job.ps1" ^
    -JobId "!JOB_ID!" ^
    -LogGroup "!LOG_GROUP!" ^
    -LogStream "!LOG_STREAM!"

:end
echo Finished.
