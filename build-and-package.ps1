#!/bin/env pwsh
# Package ThatsLit.Core for SPT 3.11.x deployment
# 
# This script builds the mod and packages it for easy installation

param(
    [string]$SPTPath = "",
    [switch]$Deploy
)

Write-Host "Building That's Lit for SPT 3.11.x..." -ForegroundColor Green

# Build the core project
Set-Location "ThatsLit.Core"
dotnet build -c Release | Out-Host
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

$dllPath = "bin\Release\net48\ThatsLit.Core.dll"
if (-not (Test-Path $dllPath)) {
    Write-Host "DLL not found at $dllPath" -ForegroundColor Red
    exit 1
}

$dllSize = (Get-Item $dllPath).Length / 1KB
Write-Host "Build successful: ThatsLit.Core.dll ($([math]::Round($dllSize, 1)) KB)" -ForegroundColor Green

# Create deployment package
$packageDir = "..\Package"
if (Test-Path $packageDir) {
    Remove-Item $packageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $packageDir | Out-Null

# Copy files
Copy-Item $dllPath "$packageDir\"
Copy-Item "..\BUILD_STATUS.md" "$packageDir\"
Copy-Item "README.md" "$packageDir\" -ErrorAction SilentlyContinue

Write-Host "Package created in: $packageDir" -ForegroundColor Green

# Optional deployment to SPT folder
if ($Deploy -and $SPTPath) {
    $pluginDir = Join-Path $SPTPath "user\mods\ThatsLit"
    if (-not (Test-Path $SPTPath)) {
        Write-Host "SPT path not found: $SPTPath" -ForegroundColor Red
        exit 1
    }
    
    New-Item -ItemType Directory -Path $pluginDir -Force | Out-Null
    Copy-Item "$packageDir\*" $pluginDir -Force
    Write-Host "Deployed to: $pluginDir" -ForegroundColor Green
}

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Copy ThatsLit.Core.dll to your SPT/user/mods/ThatsLit/ folder"
Write-Host "2. Start SPT and test bot encounters"
Write-Host "3. Look for brief aiming delays when bots first spot you"
Write-Host ""
Write-Host "See BUILD_STATUS.md for detailed testing notes"
