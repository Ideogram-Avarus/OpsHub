function Wait-PowerBIDatasetRefresh {
    param(
        [string]$WorkspaceId,
        [string]$DatasetId,
        [int]$PollSeconds = 15
    )

    while ($true) {
        $response = Invoke-PowerBIRestMethod `
            -Url "groups/$WorkspaceId/datasets/$DatasetId/refreshes`?\$top=1" `
            -Method Get

        Write-Host $response

        $refresh = ($response | ConvertFrom-Json).value[0]

        Write-Host "$DatasetId : $($refresh.status)"

        switch ($refresh.status) {
            "Completed" {
                Write-Host "Refresh completed."
                return
            }

            "Failed" {
                throw "Refresh failed."
            }

            "Disabled" {
                throw "Refresh is disabled."
            }

            default {
                Start-Sleep -Seconds $PollSeconds
            }
        }
    }
}


Write-Host "Updating Power BI report..."

Invoke-PowerBIRestMethod `
        -Url "groups/$($script:HubConfig.PowerBI.PrimaryWorkspace)/datasets/$($script:HubConfig.PowerBI.PrimaryAnalyticsDataset)/refreshes" `
        -Method Post
Invoke-PowerBIRestMethod `
        -Url "groups/$($script:HubConfig.PowerBI.SecondaryWorkspace)/datasets/$($script:HubConfig.PowerBI.SecondaryAnalyticsDataset)/refreshes" `
        -Method Post

Wait-PowerBIDatasetRefresh $script:HubConfig.PowerBI.PrimaryWorkspace $script:HubConfig.PowerBI.PrimaryAnalyticsDataset
Wait-PowerBIDatasetRefresh $script:HubConfig.PowerBI.SecondaryWorkspace $script:HubConfig.PowerBI.SecondaryAnalyticsDataset
