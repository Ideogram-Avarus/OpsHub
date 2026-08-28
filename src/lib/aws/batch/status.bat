@echo off

set JOB_ID=%~1
set RETURN_VAR=%~2

for /f "delims=" %%i in ('
  aws batch describe-jobs ^
    --jobs %JOB_ID% ^
    --query "jobs[0].status" ^
    --output text
') do (
    set STATUS=%%i
)

set "%RETURN_VAR%=%STATUS%"