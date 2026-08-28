function Get-ProjectConfig {
    $configPath = "$ProjectRoot/src/config/project.config.psd1"

    if (!(Test-Path $configPath)) {
        throw "Missing config file."
    }

    Import-PowerShellDataFile -Path $configPath
}
