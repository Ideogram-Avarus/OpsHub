@echo off
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$c=Import-PowerShellDataFile '%~dp0..\config\project.config.psd1'; $c.AWS.Batch.AnalyticsJobName"') do set JOB_NAME=%%i
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$c=Import-PowerShellDataFile '%~dp0..\config\project.config.psd1'; $c.AWS.Batch.AnalyticsJobQueue"') do set JOB_QUEUE=%%i
for /f "tokens=*" %%i in ('powershell -NoProfile -Command "$c=Import-PowerShellDataFile '%~dp0..\config\project.config.psd1'; $c.AWS.Batch.AnalyticsJobDefinition"') do set JOB_DEFINITION=%%i

aws batch submit-job ^
  --job-name "%JOB_NAME%" ^
  --job-queue "%JOB_QUEUE%" ^
  --job-definition "%JOB_DEFINITION%"
pause
