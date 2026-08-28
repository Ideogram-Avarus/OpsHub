# OpsHub

This is a PowerShell command center for day-to-day data operations. It wraps common AWS, Oracle EPM, Power BI, and local ETL workflows in a simple terminal menu so recurring operational tasks can be launched consistently.

This project is actively used and maintained as part of a real analytics operations workflow.

## What It Does

- Authenticates with AWS SSO, Power BI, and Oracle EPM Automate
- Updates an AWS-backed ODBC connection with temporary credentials
- Runs ETL and batch jobs from a single menu
- Triggers and monitors analytics refresh workflows

## Setup

Copy `src/config/project.config.example.psd1` to `src/config/project.config.psd1` and fill in your local resource names, paths, and workspace IDs. The real config file is ignored by Git so private environment details stay out of the repository.

Run the menu with:

```powershell
.\menu.ps1
```
