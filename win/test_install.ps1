$ErrorActionPreference = 'Stop'

function Get-ParsedScript([string]$Path) {
    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$errors)
    if ($errors.Count) { throw "Parse errors in ${Path}: $($errors -join '; ')" }
    return $ast
}

$installAst = Get-ParsedScript (Join-Path $PSScriptRoot 'windows_install.ps1')
$menuAst = Get-ParsedScript (Join-Path $PSScriptRoot 'install.ps1')
$null = Get-ParsedScript (Join-Path $PSScriptRoot 'windows_optimize.ps1')

$selection = $installAst.Find({
    param($node)
    $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq 'Get-PackageSelection'
}, $true).Body.GetScriptBlock()

$essential = @('1password', 'googledrive', 'git.install')
$optional = @('steam', 'signal', '1password')
$light = @(& $selection -Tier light -Essential $essential -Optional $optional)
$heavy = @(& $selection -Tier heavy -Essential $essential -Optional $optional)
foreach ($package in $light) {
    if ($heavy -notcontains $package) { throw "Heavy is missing Light package $package" }
}
foreach ($package in @('googledrive', 'steam', 'docker-desktop')) {
    if ($light -contains $package -or $heavy -notcontains $package) { throw "Incorrect tier for $package" }
}
foreach ($package in @('helium', 'comet-browser', 'claude', 'nerd-fonts-firacode', 'nerd-fonts-hack')) {
    if ($light -notcontains $package) { throw "Light is missing $package" }
}
if (($heavy | Select-Object -Unique).Count -ne $heavy.Count) { throw 'Duplicate packages selected' }

function Get-PackageArray([string]$Name) {
    $assignment = $installAst.Find({
        param($node)
        $node -is [System.Management.Automation.Language.AssignmentStatementAst] -and
        $node.Left -is [System.Management.Automation.Language.VariableExpressionAst] -and
        $node.Left.VariablePath.UserPath -eq $Name
    }, $true)
    if (-not $assignment) { throw "Missing $Name package array" }
    return @($assignment.Right.FindAll({
        param($node)
        $node -is [System.Management.Automation.Language.StringConstantExpressionAst]
    }, $true) | ForEach-Object { $_.Value })
}
$actualEssential = @(Get-PackageArray 'essentialPackages')
$actualOptional = @(Get-PackageArray 'optionalPackages')
$actualHeavy = @(& $selection -Tier heavy -Essential $actualEssential -Optional $actualOptional)
foreach ($package in @($actualEssential + $actualOptional)) {
    if ($actualHeavy -notcontains $package) { throw "Heavy omitted existing package $package" }
}

$invoke = $menuAst.Find({
    param($node)
    $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq 'Invoke-SetupScript'
}, $true).Body.GetScriptBlock()
$scriptDirectory = $PSScriptRoot
function powershell.exe {
    Write-Output 'Simulated child output'
    $global:LASTEXITCODE = $global:simulatedExit
}
$global:simulatedExit = 0
if (-not (& $invoke -Name 'windows_install.ps1' -Arguments @('-Tier', 'light'))) { throw 'Successful child reported failure' }
$global:simulatedExit = 1
if (& $invoke -Name 'windows_install.ps1' -Arguments @('-Tier', 'light')) { throw 'Failed child reported success' }

class TestRegistryKey {
    [hashtable]$Values
    TestRegistryKey([hashtable]$values) { $this.Values = $values }
    [string[]] GetValueNames() { return @($this.Values.Keys) }
    [object] GetValue([string]$name, [object]$default, [object]$options) { return $this.Values[$name].Value }
    [object] GetValueKind([string]$name) { return [Microsoft.Win32.RegistryValueKind]$this.Values[$name].Type }
}

$global:registry = @{
    'HKCU:\Control Panel\Desktop\WindowMetrics' = @{ MinAnimate = @{ Value = '1'; Type = 'String' } }
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' = @{ AllowTelemetry = @{ Value = 3; Type = 'DWord' } }
}
$global:powerPlan = '11111111-2222-3333-4444-555555555555'
$global:edition = 'Professional'
$global:failSetting = $false
$global:answers = @()
$global:tasks = @(
    [pscustomobject]@{ TaskPath = '\Microsoft\Windows\Customer Experience Improvement Program\'; TaskName = 'Consolidator'; State = 'Ready'; Description = 'Collects usage data' },
    [pscustomobject]@{ TaskPath = '\Microsoft\Windows\Customer Experience Improvement Program\'; TaskName = 'UsbCeip'; State = 'Ready'; Description = 'Collects USB usage data' },
    [pscustomobject]@{ TaskPath = '\Microsoft\Windows\WindowsUpdate\'; TaskName = 'Update'; State = 'Ready'; Description = 'Updates' }
)
function powercfg.exe {
    if ($args[0] -eq '/setactive') { $global:powerPlan = $args[1] }
    $global:LASTEXITCODE = 0
}
function Get-ItemProperty { param([string]$Path) return [pscustomobject]@{ EditionID = $global:edition; CurrentBuildNumber = '22621' } }
function Get-CimInstance { param([string]$ClassName) return [pscustomobject]@{ ProductType = 1 } }
function Get-ScheduledTask { return $global:tasks }
function Read-Host {
    param([string]$Prompt)
    if ($global:answers.Count -eq 0) { throw "Unexpected prompt: $Prompt" }
    $answer = $global:answers[0]
    $global:answers = @($global:answers | Select-Object -Skip 1)
    return $answer
}
function Disable-ScheduledTask {
    param([string]$TaskPath, [string]$TaskName)
    ($global:tasks | Where-Object { $_.TaskPath -eq $TaskPath -and $_.TaskName -eq $TaskName }).State = 'Disabled'
}
function Enable-ScheduledTask {
    param([string]$TaskPath, [string]$TaskName)
    ($global:tasks | Where-Object { $_.TaskPath -eq $TaskPath -and $_.TaskName -eq $TaskName }).State = 'Ready'
}
function Test-Path {
    param([string]$Path, [string]$LiteralPath)
    $target = if ($LiteralPath) { $LiteralPath } else { $Path }
    if ($target -like 'HKCU:*' -or $target -like 'HKLM:*') { return $global:registry.ContainsKey($target) }
    Microsoft.PowerShell.Management\Test-Path -LiteralPath $target
}
function Get-Item {
    param([string]$Path)
    if ($Path -like 'HKCU:*' -or $Path -like 'HKLM:*') { return [TestRegistryKey]::new($global:registry[$Path]) }
    Microsoft.PowerShell.Management\Get-Item -Path $Path
}
function New-Item {
    param([string]$Path, [string]$ItemType, [switch]$Force)
    if ($Path -like 'HKCU:*' -or $Path -like 'HKLM:*') {
        if (-not $global:registry.ContainsKey($Path)) { $global:registry[$Path] = @{} }
    } else {
        Microsoft.PowerShell.Management\New-Item -Path $Path -ItemType $ItemType -Force:$Force
    }
}
function New-ItemProperty {
    param([string]$Path, [string]$Name, $Value, [string]$PropertyType, [switch]$Force)
    if ($global:failSetting) { throw 'Simulated registry write failure' }
    $global:registry[$Path][$Name] = @{ Value = $Value; Type = $PropertyType }
}
function Remove-ItemProperty {
    param([string]$Path, [string]$Name)
    $global:registry[$Path].Remove($Name)
}

$oldLocalAppData = $env:LOCALAPPDATA
$testDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("pc-setup-test-" + [guid]::NewGuid().ToString())
$env:LOCALAPPDATA = $testDirectory
try {
    $optimizer = Join-Path $PSScriptRoot 'windows_optimize.ps1'
    $backupPath = Join-Path $testDirectory 'pc-setup/windows-optimization-backup.json'
    $global:answers = @('y', 'n')
    & $optimizer
    if ($global:powerPlan -ne '11111111-2222-3333-4444-555555555555') { throw 'Power plan changed' }
    if ($global:registry['HKCU:\Control Panel\Desktop\WindowMetrics'].MinAnimate.Value -ne '1') { throw 'Visual settings changed' }
    if ($global:registry['HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'].AllowTelemetry.Value -ne 1) { throw 'Pro diagnostic level incorrect' }
    if ($global:registry['HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'].AllowCrossDeviceClipboard.Value -ne 0) { throw 'Clipboard sync not restricted' }
    if ($global:registry['HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization'].AllowInputPersonalization.Value -ne 0) { throw 'Online speech not restricted' }
    if ($global:registry['HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'].DisableWebSearch.Value -ne 1) { throw 'Web search policy missing' }
    if ($global:tasks[0].State -ne 'Disabled' -or $global:tasks[1].State -ne 'Ready' -or $global:tasks[2].State -ne 'Ready') { throw 'Task approval not respected' }
    $global:answers = @('n')
    & $optimizer
    & $optimizer -Restore
    if ($global:powerPlan -ne '11111111-2222-3333-4444-555555555555') { throw 'Original power plan was not restored' }
    if ($global:registry['HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'].AllowTelemetry.Value -ne 3) { throw 'Original diagnostic setting not restored' }
    if ($global:registry['HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'].ContainsKey('AllowCrossDeviceClipboard')) { throw 'Previously absent setting was not removed' }
    if ($global:tasks[0].State -ne 'Ready' -or $global:tasks[1].State -ne 'Ready') { throw 'Task state not restored' }
    if (Test-Path -LiteralPath $backupPath) { throw 'Backup was not cleared after restoration' }

    $global:edition = 'Enterprise'
    $global:answers = @('n', 'n')
    & $optimizer
    if ($global:registry['HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'].AllowTelemetry.Value -ne 0) { throw 'Enterprise diagnostic level incorrect' }
    & $optimizer -Restore

    $global:edition = 'Core'
    try { & $optimizer; throw 'Unsupported edition unexpectedly succeeded' }
    catch { if ($_ -notmatch 'not supported by these policies') { throw } }
    if (Test-Path -LiteralPath $backupPath) { throw 'Unsupported edition created a backup' }

    $global:edition = 'Professional'
    $global:failSetting = $true
    try { & $optimizer; throw 'Registry failure unexpectedly succeeded' }
    catch { if ($_ -notmatch 'Simulated registry write failure') { throw } }
    $global:failSetting = $false
    if (-not (Test-Path -LiteralPath $backupPath)) { throw 'Backup missing after failure' }
    & $optimizer -Restore

    $legacy = @{
        PowerScheme = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
        Settings = @(@{ Path = 'HKCU:\Control Panel\Desktop\WindowMetrics'; Name = 'MinAnimate'; Exists = $true; Value = '1'; Type = 'String' })
    }
    $legacy | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $backupPath
    $global:registry['HKCU:\Control Panel\Desktop\WindowMetrics'].MinAnimate.Value = '0'
    $global:answers = @('n', 'n')
    & $optimizer
    & $optimizer -Restore
    if ($global:powerPlan -ne $legacy.PowerScheme -or $global:registry['HKCU:\Control Panel\Desktop\WindowMetrics'].MinAnimate.Value -ne '1') { throw 'Legacy backup not restored' }
    if ($global:registry['HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'].AllowTelemetry.Value -ne 3) { throw 'New settings lost when merging legacy backup' }
} finally {
    $env:LOCALAPPDATA = $oldLocalAppData
    $backup = Join-Path $testDirectory 'pc-setup/windows-optimization-backup.json'
    if (Test-Path -LiteralPath $backup) { Remove-Item -LiteralPath $backup -Force }
    $backupDir = Join-Path $testDirectory 'pc-setup'
    if (Test-Path -LiteralPath $backupDir) { [System.IO.Directory]::Delete($backupDir) }
    if (Test-Path -LiteralPath $testDirectory) { [System.IO.Directory]::Delete($testDirectory) }
}

Write-Host 'Windows installer and optimization tests passed.'
