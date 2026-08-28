$Menu = @(

    @{
        Category = "Connections"

        Items = @(
            @{
                Name = "Login to AWS"
                Description = "Authenticate with AWS SSO"
                Action = { Connect-AWS }
            }

            @{
                Name = "Update AWS ODBC connection"
                Description = "Update AWS ODBC connection"
                Action = { Update-AWS-ODBC-connection }
            }

            @{
                Name = "Login to Power BI"
                Description = "Authenticate with Power BI"
                Action = { Connect-PowerBI }
            }

            @{
                Name = "Login to EPMAutomate"
                Description = "Authenticate with Oracle EPM"
                Action = { Connect-EPMAutomate }
            }
        )
    }


    @{
        Category = "ETL"

        Items = @(
            @{
                Name = "PBCS Carga AWS"
                Description = "Run the PBCS → AWS pipeline"
                Action = { Invoke-PBCSCargaAWS }
            }

            @{
                Name = "AWS Analytics SQL"
                Description = "Run AWS Analytics SQL pipeline"
                Action = { Invoke-AWSAnalytics }
            }

            @{
                Name = "ETL Messenger"
                Description = "Run ETL Messenger"
                Action = { Invoke-ETLMessenger }
            }

            @{
                Name = "PBCS Carga Realizado"
                Description = "Run PBCS Carga Realizado"
                Action = { Invoke-PBCSCargaRealizado }
            }
        )
    }


    @{
        Category = "Analytics"

        Items = @(
            @{
                Name = "Power BI - Update Analytics"
                Description = "Power BI - Refresh Analytics "
                Action = { Update-PowerBI }
            }
        )
    }


    @{
        Category = "Pipelines"

        Items = @(
            @{
                Name = "Atualizar Forecast PBCS -> AWS"
                Description = "Execute the complete PBCS.AWS pipeline for forecast"
                Color = "Red"
                Action = { Invoke-full-PBCS-carga-AWS-pipeline }
            }
        )
    }
)
