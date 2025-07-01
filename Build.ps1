# Build Script for That's Lit SPT 3.11.x
param(
    [string]$Configuration = "Release",
    [switch]$Clean,
    [switch]$Install
)

Write-Host "=== That's Lit SPT 3.11.x Build Script ===" -ForegroundColor Green
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
    & ".\CleanupFor311.ps1"
    Write-Host ""
}

# Check if SPT path is configured
$coreProjectPath = "ThatsLit.Core\ThatsLit.Core.csproj"
if (Test-Path $coreProjectPath) {
    $content = Get-Content $coreProjectPath -Raw
    if ($content -match '<EFTPath>(\.\.\\\.\.\\\.\.)</EFTPath>') {
        Write-Host "⚠️  SPT path is set to default '../../../'" -ForegroundColor Yellow
        Write-Host "   If your build fails, run:" -ForegroundColor Yellow
        Write-Host "   .\ConfigureSPTPath.ps1 -SPTPath 'C:\Path\To\Your\SPT'" -ForegroundColor Yellow
        Write-Host ""
    }
}

# Restore packages
Write-Host "📦 Restoring NuGet packages..." -ForegroundColor Yellow
dotnet restore ThatsLit.sln
if ($LASTEXITCODE -ne 0) {
    Write-Error "Package restore failed!"
    exit 1
}

# Build solution
Write-Host ""
Write-Host "🔨 Building solution ($Configuration)..." -ForegroundColor Yellow
dotnet build ThatsLit.sln --configuration $Configuration --no-restore

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Build successful!" -ForegroundColor Green
    
    # Check output files
    $coreOutput = "ThatsLit.Core\bin\$Configuration\net48\ThatsLit.Core.dll"
    $syncOutput = "ThatsLit.Sync\bin\$Configuration\net48\ThatsLit.Sync.dll"
    
    if (Test-Path $coreOutput) {
        $coreSize = [math]::Round((Get-Item $coreOutput).Length / 1KB, 1)
        Write-Host "   📄 ThatsLit.Core.dll: $coreSize KB" -ForegroundColor Green
    }
    
    if (Test-Path $syncOutput) {
        $syncSize = [math]::Round((Get-Item $syncOutput).Length / 1KB, 1)
        Write-Host "   📄 ThatsLit.Sync.dll: $syncSize KB" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "🎉 That's Lit v1.3110.0 ready for SPT 3.11.x!" -ForegroundColor Cyan
    
    if ($Install) {
        Write-Host ""
        Write-Host "Files automatically copied to your SPT installation via build targets." -ForegroundColor Green
    }
    
} else {
    Write-Host ""
    Write-Error "❌ Build failed!"
    Write-Host ""
    Write-Host "Common solutions:" -ForegroundColor Yellow
    Write-Host "1. Configure SPT path: .\ConfigureSPTPath.ps1 -SPTPath 'C:\Your\SPT\Path'" -ForegroundColor White
    Write-Host "2. Install .NET Framework 4.8 Developer Pack" -ForegroundColor White
    Write-Host "3. Ensure SPT 3.11.x is properly installed" -ForegroundColor White
    Write-Host ""
    Write-Host "See BUILD_GUIDE.md for detailed troubleshooting." -ForegroundColor White
    exit 1
}
