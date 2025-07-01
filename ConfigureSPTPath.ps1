# Configure SPT Path for That's Lit Build
param(
    [Parameter(Mandatory=$true)]
    [string]$SPTPath
)

Write-Host "Configuring That's Lit build for SPT installation at: $SPTPath" -ForegroundColor Green

# Validate SPT installation
if (-not (Test-Path $SPTPath)) {
    Write-Error "SPT path does not exist: $SPTPath"
    exit 1
}

# Check for required assemblies
$requiredPaths = @(
    "$SPTPath\BepInEx\core\BepInEx.dll",
    "$SPTPath\BepInEx\plugins\spt\spt-core.dll",
    "$SPTPath\EscapeFromTarkov_Data\Managed\Assembly-CSharp.dll"
)

foreach ($path in $requiredPaths) {
    if (-not (Test-Path $path)) {
        Write-Warning "Missing required assembly: $path"
        Write-Host "Make sure SPT 3.11.x is properly installed and has been launched at least once."
    }
}

# Escape backslashes for XML
$escapedPath = $SPTPath -replace '\\', '\\'

# Update Core project
$coreProject = "ThatsLit.Core\ThatsLit.Core.csproj"
if (Test-Path $coreProject) {
    $content = Get-Content $coreProject -Raw
    $newContent = $content -replace '<EFTPath>.*?</EFTPath>', "<EFTPath>$escapedPath</EFTPath>"
    Set-Content $coreProject -Value $newContent -NoNewline
    Write-Host "✓ Updated $coreProject" -ForegroundColor Green
} else {
    Write-Error "Could not find $coreProject"
}

# Update Sync project
$syncProject = "ThatsLit.Sync\ThatsLit.Sync.csproj"
if (Test-Path $syncProject) {
    $content = Get-Content $syncProject -Raw
    $newContent = $content -replace '<EFTPath>.*?</EFTPath>', "<EFTPath>$escapedPath</EFTPath>"
    Set-Content $syncProject -Value $newContent -NoNewline
    Write-Host "✓ Updated $syncProject" -ForegroundColor Green
} else {
    Write-Error "Could not find $syncProject"
}

Write-Host ""
Write-Host "Configuration complete! Now you can build with:" -ForegroundColor Cyan
Write-Host "  dotnet build ThatsLit.sln --configuration Release" -ForegroundColor Yellow
Write-Host ""
Write-Host "Or open ThatsLit.sln in Visual Studio and build normally." -ForegroundColor Yellow
