param(
    [Parameter(Mandatory)]
    [string]$JobId,

    [Parameter(Mandatory)]
    [string]$LogGroup,

    [Parameter(Mandatory)]
    [string]$LogStream,

    [string]$Region = "us-east-1"
)

Write-Host ""
Write-Host "Monitoring Batch Job"
Write-Host "JobId: $JobId"
Write-Host ""

#
# Start CloudWatch tail in a separate process
#
$tail = Start-Process `
    -FilePath "aws" `
    -ArgumentList @(
        "logs",
        "tail",
        $LogGroup,
        "--region",
        $Region,
        "--follow",
        "--log-stream-names",
        $LogStream
    ) `
    -PassThru `
    -NoNewWindow

try {

    while ($true) {

        $status = (
            aws batch describe-jobs `
                --jobs $JobId `
                --query "jobs[0].status" `
                --output text
        ).Trim()

        if ($status -eq "SUCCEEDED") {
            Write-Host ""
            Write-Host "Job succeeded."
            break
        }

        if ($status -eq "FAILED") {
            Write-Host ""
            Write-Host "Job failed."
            break
        }

        Start-Sleep -Seconds 5
    }

}
finally {

    if ($tail -and -not $tail.HasExited) {
        Stop-Process -Id $tail.Id -Force
    }
}