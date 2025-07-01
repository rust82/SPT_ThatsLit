# Clean up old .NET 4.7.2 build artifacts for SPT 3.11.x compatibility update
Write-Host "Cleaning up old build artifacts for SPT 3.11.x update..."

# Clean Core project
$coreProject = "ThatsLit.Core"
if (Test-Path "$coreProject\bin\Debug\net472") {
    Write-Host "Removing $coreProject\bin\Debug\net472"
    Remove-Item "$coreProject\bin\Debug\net472" -Recurse -Force
}
if (Test-Path "$coreProject\obj\Debug\net472") {
    Write-Host "Removing $coreProject\obj\Debug\net472"
    Remove-Item "$coreProject\obj\Debug\net472" -Recurse -Force
}

# Clean Sync project
$syncProject = "ThatsLit.Sync"
if (Test-Path "$syncProject\bin\Debug\net472") {
    Write-Host "Removing $syncProject\bin\Debug\net472"
    Remove-Item "$syncProject\bin\Debug\net472" -Recurse -Force
}
if (Test-Path "$syncProject\obj\Debug\net472") {
    Write-Host "Removing $syncProject\obj\Debug\net472"
    Remove-Item "$syncProject\obj\Debug\net472" -Recurse -Force
}

Write-Host "Cleanup complete! Ready for SPT 3.11.x build."
Write-Host "Run 'dotnet build' or build in Visual Studio to create new .NET 4.8 artifacts."
