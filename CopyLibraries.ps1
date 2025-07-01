param(
    [Parameter(Mandatory=$true)]
    [string]$SPTPath
)

$ReferencesPath = ".\References"

Write-Host "Setting up local library references for That's Lit mod..." -ForegroundColor Green
Write-Host "SPT Path: $SPTPath" -ForegroundColor Cyan

# Validate SPT path
if (!(Test-Path $SPTPath)) {
    Write-Error "SPT path does not exist: $SPTPath"
    exit 1
}

# Create directories if they don't exist
Write-Host "Creating reference directories..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$ReferencesPath\BepInEx" | Out-Null
New-Item -ItemType Directory -Force -Path "$ReferencesPath\SPT" | Out-Null
New-Item -ItemType Directory -Force -Path "$ReferencesPath\Game" | Out-Null
New-Item -ItemType Directory -Force -Path "$ReferencesPath\Fika" | Out-Null

# Copy BepInEx libraries
Write-Host "Copying BepInEx libraries..." -ForegroundColor Yellow
$bepInExLibs = @("BepInEx.dll", "0Harmony.dll")
foreach ($lib in $bepInExLibs) {
    $sourcePath = "$SPTPath\BepInEx\core\$lib"
    if (Test-Path $sourcePath) {
        Copy-Item $sourcePath "$ReferencesPath\BepInEx\"
        Write-Host "  ✓ Copied $lib" -ForegroundColor Green
    } else {
        Write-Warning "  ✗ BepInEx library not found: $lib"
    }
}

# Copy SPT libraries
Write-Host "Copying SPT libraries..." -ForegroundColor Yellow
$sptLibs = @("spt-core.dll", "spt-reflection.dll")
foreach ($lib in $sptLibs) {
    $sourcePath = "$SPTPath\BepInEx\plugins\spt\$lib"
    if (Test-Path $sourcePath) {
        Copy-Item $sourcePath "$ReferencesPath\SPT\"
        Write-Host "  ✓ Copied $lib" -ForegroundColor Green
    } else {
        Write-Warning "  ✗ SPT library not found: $lib"
    }
}

# Copy Game libraries
Write-Host "Copying game libraries..." -ForegroundColor Yellow
$gameLibs = @(
    "Assembly-CSharp.dll",
    "Comfort.dll",
    "DissonanceVoip.dll",
    "Newtonsoft.Json.dll",
    "UnityEngine.dll",
    "UnityEngine.CoreModule.dll",
    "UnityEngine.UI.dll",
    "UnityEngine.AudioModule.dll",
    "Unity.TextMeshPro.dll",
    "Sirenix.Serialization.dll",
    "UnityEngine.InputLegacyModule.dll",
    "UnityEngine.JSONSerializeModule.dll",
    "UnityEngine.IMGUIModule.dll",
    "UnityEngine.PhysicsModule.dll",
    "UnityEngine.TerrainModule.dll",
    "UnityEngine.TextRenderingModule.dll",
    "ItemComponent.Types.dll"
)

foreach ($lib in $gameLibs) {
    $sourcePath = "$SPTPath\EscapeFromTarkov_Data\Managed\$lib"
    if (Test-Path $sourcePath) {
        Copy-Item $sourcePath "$ReferencesPath\Game\"
        Write-Host "  ✓ Copied $lib" -ForegroundColor Green
    } else {
        Write-Warning "  ✗ Game library not found: $lib"
    }
}

# Try to copy Fika (optional)
Write-Host "Checking for optional Fika mod..." -ForegroundColor Yellow
$fikaPath = "$SPTPath\BepInEx\plugins\Fika.Core.dll"
if (Test-Path $fikaPath) {
    Copy-Item $fikaPath "$ReferencesPath\Fika\"
    Write-Host "  ✓ Copied Fika.Core.dll" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Fika.Core.dll not found (optional dependency)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Library setup complete!" -ForegroundColor Green
Write-Host "You can now build the project using local references with: .\Build.ps1" -ForegroundColor Cyan
