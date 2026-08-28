@echo off

set FUNCTION_NAME=%~1
set PAYLOAD=%~2
set RETURN_VAR=%~3

if "%RETURN_VAR%"=="" (
    echo Missing return variable name
    exit /b 1
)

set RESPONSE_FILE=%TEMP%\lambda-response-%RANDOM%.json

echo Invoking %FUNCTION_NAME%...

if /I "%PAYLOAD%"=="EMPTY" (
    aws lambda invoke ^
        --function-name "%FUNCTION_NAME%" ^
        --payload "{}" ^
        "%RESPONSE_FILE%" ^
        --cli-binary-format raw-in-base64-out ^
        --debug
) else if "%PAYLOAD%"=="" (
    aws lambda invoke ^
        --function-name "%FUNCTION_NAME%" ^
        "%RESPONSE_FILE%"
) else (
    aws lambda invoke ^
        --function-name "%FUNCTION_NAME%" ^
        --payload fileb://"%PAYLOAD%" ^
        "%RESPONSE_FILE%"
)

if errorlevel 1 exit /b 1

set "%RETURN_VAR%=%RESPONSE_FILE%"

exit /b 0