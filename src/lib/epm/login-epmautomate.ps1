


$credential = & "$ProjectRoot\src\credentials\get-credential.ps1" -Target "EPM_AUTOMATE"

epmautomate login $credential.Username $credential.Password $script:HubConfig.EPM.Url

Remove-Variable credential
