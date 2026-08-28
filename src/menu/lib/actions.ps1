

function Connect-AWS {
    aws sso login
}


function Connect-PowerBI {
    Connect-PowerBIServiceAccount 
}


function Connect-EPMAutomate {
    . "$ProjectRoot\src\lib\epm\login-epmautomate.ps1"
}


function Update-AWS-ODBC-connection {
    . "$ProjectRoot\src\actions\update-aws-odbc-connection.ps1"
}

function Invoke-PBCSCargaAWS {

    Write-Host "Calling EPMAUTOMATE Batch..." -ForegroundColor Yellow

    & "$ProjectRoot\src\actions\run-pbcs-carga-aws.ps1"
}


function Invoke-AWSAnalytics {

    Write-Host "Calling AWS Batch..." -ForegroundColor Yellow

    & "$ProjectRoot\src\actions\update-analytics-follow.bat"
}


function Update-PowerBI {

    Write-Host "Sending update request to PowerBI..." -ForegroundColor Yellow

    . "$ProjectRoot\src\actions\update-analytics-bi.ps1"
}


function Invoke-ETLMessenger {

    Write-Host "Calling ETL Messenger..." -ForegroundColor Yellow

    . "$ProjectRoot\src\actions\run-etl-messenger.ps1"
}


function Invoke-full-PBCS-carga-AWS-pipeline {

    Invoke-PBCSCargaAWS

    Write-Host "Waiting 5 minutes for crawler..." -ForegroundColor DarkYellow
    Start-Sleep -Seconds 180

    Invoke-AWSAnalytics

    Update-PowerBI
}

function Invoke-PBCSCargaRealizado {

    Write-Host "Calling PBCS-carga-realizado..." -ForegroundColor Yellow

    & "$ProjectRoot\src\actions\run-pbcs-carga-realizado.ps1"
}

