. "$ProjectRoot\..\config\get-project-config.ps1"

$config = Get-ProjectConfig

Set-Location -Path $config.Paths.PBCSCargaAWS

& conda "activate" "bidev"

python "src/test.py"
