function Show-Header {
    param(
        [string]$Title = "PIPELINE TOOL"
    )

    Write-Host "===================================" -ForegroundColor DarkCyan
    Write-Host "        $Title" -ForegroundColor Cyan
    Write-Host "===================================" -ForegroundColor DarkCyan
    Write-Host ""
}


function Show-MainMenu {
    param(
        [array]$Menu
    )

    Clear-Host
    Show-Header

    for ($i = 0; $i -lt $Menu.Count; $i++) {
        Write-Host "$($i + 1). $($Menu[$i].Category)" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "ESC. Exit" -ForegroundColor Yellow
    Write-Host ""
}


function Show-CategoryMenu {
    param(
        [hashtable]$Category
    )

    while ($true) {

        Clear-Host
        Show-Header -Title "PIPELINE TOOL > $($Category.Category)"

        $items = $Category.Items

        for ($i = 0; $i -lt $items.Count; $i++) {

            $item = $items[$i]

            $color = if ($item.ContainsKey("Color")) {
                $item.Color
            }
            else {
                "White"
            }

            Write-Host "$($i + 1). $($item.Name)" -ForegroundColor $color
            Write-Host "   $($item.Description)" -ForegroundColor DarkGray
        }

        Write-Host ""
        Write-Host "ESC. Back" -ForegroundColor Yellow
        Write-Host ""

        $key = [System.Console]::ReadKey($true)

        if ($key.Key -eq "Escape") {
            return
        }

        $index = [int]$key.KeyChar.ToString() - 1

        if ($index -lt 0 -or $index -ge $items.Count) {
            Write-Host "Invalid option." -ForegroundColor Red
            Start-Sleep -Seconds 1
            continue
        }

        $item = $items[$index]

        Clear-Host
        Show-Header -Title $item.Name

        try {
            & $item.Action

            Write-Host ""
            Write-Host "Completed." -ForegroundColor Green
        }
        catch {
            Write-Host ""
            Write-Host "ERROR:" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }

        Write-Host ""
        Write-Host "Press any key to continue..."
        [System.Console]::ReadKey($true) | Out-Null
    }
}


function Start-Menu {
    param(
        [array]$Menu
    )

    :mainLoop while ($true) {

        Show-MainMenu -Menu $Menu

        $key = [System.Console]::ReadKey($true)

        if ($key.Key -eq "Escape") {
            Clear-Host
            Write-Host "Exiting..." -ForegroundColor Green
            break mainLoop
        }

        $index = [int]$key.KeyChar.ToString() - 1

        if ($index -lt 0 -or $index -ge $Menu.Count) {
            Write-Host "Invalid option." -ForegroundColor Red
            Start-Sleep -Seconds 1
            continue
        }

        Show-CategoryMenu -Category $Menu[$index]
    }
}