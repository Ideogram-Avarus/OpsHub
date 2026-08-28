@echo off

set FUNCTION_NAME=%~1
set RETURN_GROUP=%~2
set RETURN_STREAM=%~3

set LOG_GROUP=/aws/lambda/%FUNCTION_NAME%

for /f "delims=" %%i in ('
    aws logs describe-log-streams ^
        --log-group-name "%LOG_GROUP%" ^
        --order-by LastEventTime ^
        --descending ^
        --max-items 1 ^
        --query "logStreams[0].logStreamName" ^
        --output text
') do (
    set LOG_STREAM=%%i
)

set "%RETURN_GROUP%=%LOG_GROUP%"
set "%RETURN_STREAM%=%LOG_STREAM%"

exit /b 0