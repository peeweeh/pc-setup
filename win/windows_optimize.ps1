param([switch]$Restore)

$ErrorActionPreference = 'Stop'
$backupDirectory = Join-Path $env:LOCALAPPDATA 'pc-setup'
$backupPath = Join-Path $backupDirectory 'windows-optimization-backup.json'

function Save-Backup {
    New-Item -ItemType Directory -Path $backupDirectory -Force | Out-Null
    $temporaryPath = "$backupPath.tmp"
    try {
        $backup | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $temporaryPath -Encoding UTF8
        Move-Item -LiteralPath $temporaryPath -Destination $backupPath -Force
    } finally {
        if (Test-Path -LiteralPath $temporaryPath) { Remove-Item -LiteralPath $temporaryPath -Force }
    }
}

try {
    if (Test-Path -LiteralPath $backupPath) {
        $backup = Get-Content -LiteralPath $backupPath -Raw | ConvertFrom-Json
        if ($null -eq $backup -or $null -eq $backup.Settings) {
            throw "Invalid optimization backup at $backupPath; no changes made."
        }
        if (-not $backup.PSObject.Properties['Tasks']) {
            $backup | Add-Member -NotePropertyName Tasks -NotePropertyValue @()
        }
    } elseif ($Restore) {
        throw "No optimization backup exists at $backupPath."
    } else {
        $backup = [pscustomobject]@{ Settings = @(); Tasks = @() }
    }

    if ($Restore) {
        if ($backup.PSObject.Properties['PowerScheme'] -and $backup.PowerScheme) {
            & powercfg.exe /setactive $backup.PowerScheme
            if ($LASTEXITCODE -ne 0) { throw "Could not restore the power plan (exit $LASTEXITCODE)." }
        }
        foreach ($entry in $backup.Settings) {
            if ($entry.Exists) {
                New-Item -Path $entry.Path -Force | Out-Null
                New-ItemProperty -Path $entry.Path -Name $entry.Name -Value $entry.Value -PropertyType $entry.Type -Force | Out-Null
            } elseif (Test-Path -LiteralPath $entry.Path) {
                $key = Get-Item -Path $entry.Path
                if ($key.GetValueNames() -contains $entry.Name) {
                    Remove-ItemProperty -Path $entry.Path -Name $entry.Name
                }
            }
        }
        foreach ($task in $backup.Tasks) {
            Enable-ScheduledTask -TaskPath $task.Path -TaskName $task.Name | Out-Null
        }
        Remove-Item -LiteralPath $backupPath -Force
        Write-Host "Saved settings restored. Restart Windows to apply policy changes." -ForegroundColor Green
        return
    }

    $windows = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $edition = $windows.EditionID
    $server = $os.ProductType -ne 1
    $enterprise = $edition -match '^Enterprise' -or $edition -match '^Education' -or $server
    $supported = $enterprise -or $edition -match '^Professional'
    if (-not $supported -or [int]$windows.CurrentBuildNumber -lt 17763) {
        throw "Windows edition '$edition' or build $($windows.CurrentBuildNumber) is not supported by these policies. No settings were changed; use Windows Settings to review privacy options."
    }

    $diagnosticLevel = if ($enterprise) { 0 } else { 1 }
    $settings = @(
        @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'; Name = 'AllowTelemetry'; Value = $diagnosticLevel },
        @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo'; Name = 'DisabledByGroupPolicy'; Value = 1 },
        @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization'; Name = 'DODownloadMode'; Value = 0 },
        @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'; Name = 'AllowCrossDeviceClipboard'; Value = 0 },
        @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization'; Name = 'AllowInputPersonalization'; Value = 0 },
        @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'; Name = 'DisableWebSearch'; Value = 1 },
        @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'; Name = 'ConnectedSearchUseWeb'; Value = 0 }
    )
    foreach ($setting in $settings) {
        $saved = @($backup.Settings | Where-Object { $_.Path -eq $setting.Path -and $_.Name -eq $setting.Name })
        if ($saved.Count -eq 0) {
            $key = if (Test-Path -LiteralPath $setting.Path) { Get-Item -Path $setting.Path } else { $null }
            $exists = $null -ne $key -and $key.GetValueNames() -contains $setting.Name
            $backup.Settings += [pscustomobject]@{
                Path = $setting.Path
                Name = $setting.Name
                Exists = $exists
                Value = if ($exists) { $key.GetValue($setting.Name, $null, 'DoNotExpandEnvironmentNames') } else { $null }
                Type = if ($exists) { $key.GetValueKind($setting.Name).ToString() } else { $null }
            }
        }
    }
    Save-Backup
    foreach ($setting in $settings) {
        New-Item -Path $setting.Path -Force | Out-Null
        New-ItemProperty -Path $setting.Path -Name $setting.Name -Value $setting.Value -PropertyType DWord -Force | Out-Null
    }

    if ($enterprise) {
        Write-Host 'Requested diagnostic data off. Microsoft recommends Required data for Windows Update failure diagnostics.' -ForegroundColor Yellow
    } else {
        Write-Host 'Requested Required diagnostic data; diagnostic data off is not supported on Pro.' -ForegroundColor Yellow
    }
    Write-Host 'Requested ad ID off, no Delivery Optimization peers, no clipboard sync or online speech, and reduced web search.' -ForegroundColor Yellow
    Write-Host 'Policy effectiveness depends on edition, Windows version, and management policies. Web search may still connect; check Windows settings and effective policies after restarting.' -ForegroundColor Yellow

    $tasks = @(Get-ScheduledTask | Where-Object { $_.TaskPath -eq '\Microsoft\Windows\Customer Experience Improvement Program\' })
    if ($tasks.Count -eq 0) {
        Write-Host 'No Customer Experience Improvement Program tasks found.'
    }
    foreach ($task in $tasks) {
        Write-Host "`nTask: $($task.TaskPath)$($task.TaskName) [$($task.State)]"
        Write-Host "Description: $($task.Description)"
        if ($task.State -eq 'Disabled') { continue }
        if ((Read-Host 'Disable this task? [y/N]') -notmatch '^[Yy]$') { continue }
        $saved = @($backup.Tasks | Where-Object { $_.Path -eq $task.TaskPath -and $_.Name -eq $task.TaskName })
        if ($saved.Count -eq 0) {
            $backup.Tasks += [pscustomobject]@{ Path = $task.TaskPath; Name = $task.TaskName }
            Save-Backup
        }
        Disable-ScheduledTask -TaskPath $task.TaskPath -TaskName $task.TaskName | Out-Null
    }
    Write-Host 'Restart Windows, then verify the effective settings. Restore with: powershell -File win\windows_optimize.ps1 -Restore' -ForegroundColor Green
} catch {
    Write-Host "Optimization failed: $_" -ForegroundColor Red
    Write-Host "If changes were made, restore using the backup at $backupPath." -ForegroundColor Yellow
    throw
}
