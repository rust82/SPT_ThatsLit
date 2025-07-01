# Build Core Plugin Only - That's Lit SPT 3.11.x
param(
    [string]$Configuration = "Release",
    [switch]$Clean
)

Write-Host "=== That's Lit Core Plugin Build Script ===" -ForegroundColor Green
Write-Host ""

# Check if References folder exists and has required libraries
$referencesPath = ".\References"
$requiredPaths = @(
    "$referencesPath\BepInEx\BepInEx.dll",
    "$referencesPath\BepInEx\0Harmony.dll",
    "$referencesPath\SPT\spt-core.dll",
    "$referencesPath\SPT\spt-reflection.dll",
    "$referencesPath\Game\Assembly-CSharp.dll",
    "$referencesPath\Game\Comfort.dll",
    "$referencesPath\Game\UnityEngine.dll",
    "$referencesPath\Game\UnityEngine.CoreModule.dll",
    "$referencesPath\Game\UnityEngine.UI.dll"
)

$missingLibs = @()
foreach ($path in $requiredPaths) {
    if (!(Test-Path $path)) {
        $missingLibs += $path
    }
}

if ($missingLibs.Count -gt 0) {
    Write-Host "❌ Missing required libraries in References folder:" -ForegroundColor Red
    foreach ($lib in $missingLibs) {
        Write-Host "  - $lib" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Please run: .\CopyLibraries.ps1 -SPTPath 'C:\Path\To\Your\SPT'" -ForegroundColor Cyan
    Write-Host "Or manually copy libraries as described in LIBRARY_SETUP.md" -ForegroundColor Cyan
    exit 1
}

Write-Host "✅ All required libraries found in References folder" -ForegroundColor Green
Write-Host ""

# Clean if requested
if ($Clean) {
    Write-Host "🧹 Cleaning old build artifacts..." -ForegroundColor Yellow
    if (Test-Path "ThatsLit.Core\bin") { Remove-Item "ThatsLit.Core\bin" -Recurse -Force }
    if (Test-Path "ThatsLit.Core\obj") { Remove-Item "ThatsLit.Core\obj" -Recurse -Force }
    Write-Host ""
}

# Restore packages for Core project
Write-Host "📦 Restoring NuGet packages for Core project..." -ForegroundColor Yellow
dotnet restore ThatsLit.Core\ThatsLit.Core.csproj
if ($LASTEXITCODE -ne 0) {
    Write-Error "Package restore failed!"
    exit 1
}

# Build Core project only
Write-Host ""
Write-Host "🔨 Building Core project ($Configuration)..." -ForegroundColor Yellow
dotnet build ThatsLit.Core\ThatsLit.Core.csproj --configuration $Configuration --no-restore

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Core plugin build successful!" -ForegroundColor Green
    
    # Check output files
    $coreOutput = "ThatsLit.Core\bin\$Configuration\net48\ThatsLit.Core.dll"
    
    if (Test-Path $coreOutput) {
        $coreSize = [math]::Round((Get-Item $coreOutput).Length / 1KB, 1)
        Write-Host "   📄 ThatsLit.Core.dll: $coreSize KB" -ForegroundColor Green
        
        # Show installation instructions
        Write-Host ""
        Write-Host "🚀 Installation Instructions:" -ForegroundColor Cyan
        Write-Host "1. Copy ThatsLit.Core.dll to your SPT installation:" -ForegroundColor White
        Write-Host "   {SPT}\BepInEx\plugins\ThatsLit\" -ForegroundColor Yellow
        Write-Host "2. Copy the contents of ThatsLit.Core\Packed\ to the same folder" -ForegroundColor White
        Write-Host "3. Launch SPT and enjoy!" -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "🎉 That's Lit Core v1.3110.0 ready for SPT 3.11.x!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Note: Sync plugin skipped (requires Fika mod)" -ForegroundColor Yellow
    Write-Host "See BUILD_STATUS.md for details on disabled features" -ForegroundColor Yellow
    
} else {
    Write-Host ""
    Write-Error "❌ Core plugin build failed!"
    Write-Host ""
    Write-Host "Common solutions:" -ForegroundColor Yellow
    Write-Host "1. Ensure all required libraries are in References folder" -ForegroundColor White
    Write-Host "2. Install .NET Framework 4.8 Developer Pack" -ForegroundColor White
    Write-Host "3. Run: .\CopyLibraries.ps1 -SPTPath 'C:\Your\SPT\Path'" -ForegroundColor White
    Write-Host ""
    Write-Host "See BUILD_GUIDE.md for detailed troubleshooting." -ForegroundColor White
    exit 1
}
