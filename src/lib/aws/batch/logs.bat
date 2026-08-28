@echo off

set JOB_ID=%~1
set RETURN_GROUP=%~2
set RETURN_STREAM=%~3

for /f "delims=" %%i in ('
  aws batch describe-jobs ^
    --jobs %JOB_ID% ^
    --query "jobs[0].container.logStreamName" ^
    --output text
') do (
    set LOG_STREAM=%%i
)

for /f "delims=" %%i in ('
  aws batch describe-jobs ^
    --jobs %JOB_ID% ^
    --region us-east-1 ^
    --query "jobs[0].container.logConfiguration.options.\"awslogs-group\"" ^
    --output text
') do (
    set LOG_GROUP=%%i
)

set "%RETURN_GROUP%=%LOG_GROUP%"
set "%RETURN_STREAM%=%LOG_STREAM%"