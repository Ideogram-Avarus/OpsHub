
$dsnName = $script:HubConfig.AWS.DsnName

Write-Host "------------------------------------"
Write-Host "Atualizando ODBC com credenciais AWS"
Write-Host "Profile: $env:AWS_PROFILE"
Write-Host "DSN: $dsnName"
Write-Host "------------------------------------"

Write-Host "Obtendo credenciais temporarias..."

$creds = aws configure export-credentials | ConvertFrom-Json

Write-Host "------------------------------------"
Write-Host "Credenciais temporarias recebidas."
Write-Host "SessionToken length:" $creds.SessionToken.Length

$path = "HKCU:\Software\ODBC\ODBC.INI\$dsnName"

Write-Host "Registro alvo: $path"

if (!(Test-Path $path)) {
    Write-Host "DSN nao existe. Criando..."
    New-Item -Path $path -Force | Out-Null
}
else {
    Write-Host "DSN encontrado."
}

Write-Host "Gravando credenciais no registro..."

Set-ItemProperty -Path $path -Name "UID" -Value $creds.AccessKeyId
$encodedPwd = [Convert]::ToBase64String(
    [System.Text.Encoding]::UTF8.GetBytes($creds.SecretAccessKey)
)
Set-ItemProperty -Path $path -Name "PWD" -Value $encodedPwd
Set-ItemProperty -Path $path -Name "SessionToken" -Value $creds.SessionToken

Write-Host "Credenciais gravadas com sucesso."
Write-Host "Processo finalizado."
Write-Host "------------------------------------"
