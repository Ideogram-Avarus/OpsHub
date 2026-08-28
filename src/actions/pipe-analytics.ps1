
Write-Host "Logging in to Power BI..."

Connect-PowerBIServiceAccount

Start-Process -Wait "cmd.exe" "/c `"$PSScriptRoot\update-analytics-follow.bat`""

Write-Host "Updating Power BI..."
. "$PSScriptRoot\update-analytics-bi.ps1"
