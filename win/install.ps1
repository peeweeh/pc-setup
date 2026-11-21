# Interactive Windows setup
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run this installer as Administrator." -ForegroundColor Red
    exit 1
}

$scriptDirectory = $PSScriptRoot

$script:Animate = -not [Console]::IsOutputRedirected -and -not $env:PC_SETUP_NO_ANIM -and -not $env:CI

$script:Banner = @(
    ' ____   ____   ____  _____ _____ _   _ ____  ',
    '|  _ \ / ___| / ___|| ____|_   _| | | |  _ \ ',
    '| |_) | |     \___ \|  _|   | | | | | | |_) |',
    '|  __/| |___   ___) | |___  | | | |_| |  __/ ',
    '|_|    \____| |____/|_____| |_|  \___/|_|    '
)

function Write-Typed {
    param([string]$Text, [ConsoleColor]$Color = 'Green', [int]$DelayMs = 8)
    if (-not $script:Animate) {
        Write-Host $Text -ForegroundColor $Color -NoNewline
        return
    }
    foreach ($char in $Text.ToCharArray()) {
        Write-Host $char -ForegroundColor $Color -NoNewline
        Start-Sleep -Milliseconds $DelayMs
    }
}

function Write-Boot {
    param([string]$Text, [string]$Tag, [ConsoleColor]$Color = 'Green')
    Write-Typed "  $Text " -Color DarkGreen
    Write-Host "[$Tag]" -ForegroundColor $Color
    if ($script:Animate) { Start-Sleep -Milliseconds 100 }
}

function Move-Cursor {
    param([int]$X, [int]$Y)
    try {
        [Console]::SetCursorPosition($X, [Math]::Max(0, $Y))
        return $true
    } catch {
        return $false
    }
}

function Show-Banner {
    if (-not $script:Animate) {
        foreach ($line in $script:Banner) { Write-Host $line -ForegroundColor Green }
        return
    }
    $top = [Console]::CursorTop
    foreach ($line in $script:Banner) {
        Write-Host $line -ForegroundColor Green
        Start-Sleep -Milliseconds 50
    }
    for ($flash = 0; $flash -lt 2; $flash++) {
        foreach ($colour in @('White', 'Green')) {
            if (-not (Move-Cursor -X 0 -Y $top)) { return }
            foreach ($line in $script:Banner) { Write-Host $line -ForegroundColor $colour }
            Start-Sleep -Milliseconds 70
        }
    }
}

function Invoke-MatrixRain {
    if (-not $script:Animate) { return }
    try {
        $width = [Console]::WindowWidth
        $height = [Console]::WindowHeight
    } catch {
        $width = 120
        $height = 30
    }
    if ($width -lt 20 -or $height -lt 10) { return }
    $glyphs = '0123456789ABCDEF<>/\|*+-='
    $rows = $height - 1
    $heads = @{}
    for ($x = 0; $x -lt $width - 1; $x += 2) { $heads[$x] = Get-Random -Minimum 0 -Maximum $rows }
    [Console]::Clear()
    :frames for ($frame = 0; $frame -lt 30; $frame++) {
        foreach ($x in @($heads.Keys)) {
            $y = $heads[$x]
            if ($y -gt 0 -and -not (Move-Cursor -X $x -Y ($y - 1))) { break frames }
            if ($y -gt 0) {
                [Console]::ForegroundColor = 'DarkGreen'
                [Console]::Write($glyphs[(Get-Random -Maximum $glyphs.Length)])
            }
            if (-not (Move-Cursor -X $x -Y $y)) { break frames }
            [Console]::ForegroundColor = 'White'
            [Console]::Write($glyphs[(Get-Random -Maximum $glyphs.Length)])
            $heads[$x] = if ($y + 1 -ge $rows) { 0 } else { $y + 1 }
        }
        Start-Sleep -Milliseconds 40
    }
    [Console]::ResetColor()
    [Console]::Clear()
}

function Invoke-Party {
    if (-not $script:Animate) {
        Write-Host 'Party mode needs an interactive console.' -ForegroundColor Yellow
        return
    }
    Invoke-MatrixRain
    $colours = @('Red', 'Yellow', 'Green', 'Cyan', 'Blue', 'Magenta', 'White')
    foreach ($line in $script:Banner) { Write-Host $line }
    $top = [Console]::CursorTop - $script:Banner.Count
    for ($i = 0; $i -lt 28; $i++) {
        if (-not (Move-Cursor -X 0 -Y $top)) { break }
        $colour = $colours[$i % $colours.Count]
        foreach ($line in $script:Banner) { Write-Host $line -ForegroundColor $colour }
        Start-Sleep -Milliseconds 80
    }
    [Console]::Clear()
}

function Write-MenuItem {
    param([string]$Key, [string]$Text)
    Write-Host "  [$Key] " -NoNewline -ForegroundColor White
    Write-Typed $Text -DelayMs 4
    Write-Host ''
}

function Show-Menu {
    Write-MenuItem '1' 'Install Light - core apps, developer tools and fonts'
    Write-MenuItem '2' 'Install Heavy - Light plus cloud, Docker, games and other large apps'
    Write-MenuItem '3' 'Install Optimizations - privacy policies and optional background-task review'
    Write-MenuItem '4' 'Install All - Heavy followed by optimizations'
    Write-MenuItem '0' 'Exit'
}

function Invoke-SetupScript {
    param([string]$Name, [string[]]$Arguments = @())

    $temporary = $false
    $path = if ($scriptDirectory) { Join-Path $scriptDirectory $Name } else { $null }
    if (-not $path -or -not (Test-Path -LiteralPath $path)) {
        $temporary = $true
        $path = Join-Path $env:TEMP ("pc-setup-" + [guid]::NewGuid().ToString() + ".ps1")
        try {
            Invoke-WebRequest -Uri "https://raw.githubusercontent.com/peeweeh/pc-setup/master/win/$Name" -OutFile $path -UseBasicParsing -ErrorAction Stop
        } catch {
            Write-Host "Could not download ${Name}: $_" -ForegroundColor Red
            if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Force }
            return $false
        }
    }

    try {
        $global:LASTEXITCODE = $null
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $path @Arguments | ForEach-Object { Write-Host $_ }
        if ($null -eq $LASTEXITCODE -or $LASTEXITCODE -ne 0) {
            Write-Host "$Name failed with exit code $LASTEXITCODE." -ForegroundColor Red
            return $false
        }
        return $true
    } catch {
        Write-Host "Could not execute ${Name}: $_" -ForegroundColor Red
        return $false
    } finally {
        if ($temporary -and (Test-Path -LiteralPath $path)) {
            Remove-Item -LiteralPath $path -Force
        }
    }
}

Invoke-MatrixRain
Show-Banner
Write-Host ''
Write-Boot -Text 'booting setup menu' -Tag ' OK '
Write-Boot -Text 'tiers: light, heavy, optimizations' -Tag 'READY'
Write-Boot -Text 'awaiting selection' -Tag '>>' -Color Yellow
Write-Host ''
Write-Host 'PC Setup for Windows' -ForegroundColor Cyan
Show-Menu

do {
    Write-Host '> ' -NoNewline -ForegroundColor White
    $choice = Read-Host 'Select an option [0-4]'
    if ($null -eq $choice) { exit 1 }
    if ($choice -eq 'party') {
        Invoke-Party
        Show-Menu
    }
} while ($choice -notin @('0', '1', '2', '3', '4'))

if ($choice -eq '0') { exit 0 }

if ($choice -in @('3', '4')) {
    Write-Host "Optimizations restrict diagnostic data, advertising ID, update sharing, online speech, clipboard sync and web search." -ForegroundColor Yellow
    Write-Host "Effectiveness varies by Windows edition and management policy. You can review background tasks individually." -ForegroundColor Yellow
    Write-Host "Original settings are saved. Power, visual effects, Defender and update availability are not changed." -ForegroundColor Yellow
    if ((Read-Host "Continue? [y/N]") -notmatch '^[Yy]$') {
        Write-Host "Cancelled."
        exit 0
    }
}

if ($choice -in @('1', '2', '4')) {
    $tier = if ($choice -eq '1') { 'light' } else { 'heavy' }
    if (-not (Invoke-SetupScript -Name 'windows_install.ps1' -Arguments @('-Tier', $tier))) { exit 1 }
}
if ($choice -in @('3', '4')) {
    if (-not (Invoke-SetupScript -Name 'windows_optimize.ps1')) { exit 1 }
}
Write-Host "Setup finished." -ForegroundColor Green
