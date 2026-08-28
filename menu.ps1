$ProjectRoot = $PSScriptRoot

. "$ProjectRoot\src\config\get-project-config.ps1"

$script:HubConfig = Get-ProjectConfig

$env:AWS_PROFILE = $script:HubConfig.AWS.Profile
$env:AWS_REGION = $script:HubConfig.AWS.Region


. "$ProjectRoot\src\menu\lib\actions.ps1"
. "$ProjectRoot\src\menu\lib\menu.ps1"
. "$ProjectRoot\src\menu\menu.definition.ps1"

Start-Menu -Menu $Menu
