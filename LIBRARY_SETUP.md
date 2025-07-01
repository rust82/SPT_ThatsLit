# Library Setup Guide

This guide explains how to set up the required libraries in the `References` folder for building the That's Lit mod without requiring an SPT installation path.

## Required Libraries

Copy the following files from your SPT 3.11.x installation to the appropriate subfolders in the `References` folder:

### References/BepInEx/
Copy from `<SPT_PATH>/BepInEx/core/`:
- `BepInEx.dll`
- `0Harmony.dll`

### References/SPT/
Copy from `<SPT_PATH>/BepInEx/plugins/spt/`:
- `spt-core.dll`
- `spt-reflection.dll`

### References/Game/
Copy from `<SPT_PATH>/EscapeFromTarkov_Data/Managed/`:
- `Assembly-CSharp.dll`
- `Comfort.dll`
- `DissonanceVoip.dll`
- `Newtonsoft.Json.dll`
- `UnityEngine.dll`
- `UnityEngine.CoreModule.dll`
- `UnityEngine.UI.dll`
- `UnityEngine.AudioModule.dll`
- `Unity.TextMeshPro.dll`
- `Sirenix.Serialization.dll`
- `UnityEngine.InputLegacyModule.dll`
- `UnityEngine.JSONSerializeModule.dll`
- `UnityEngine.IMGUIModule.dll`
- `UnityEngine.PhysicsModule.dll`
- `UnityEngine.TerrainModule.dll`
- `UnityEngine.TextRenderingModule.dll`
- `ItemComponent.Types.dll`

### Optional: References/Fika/ (for Sync plugin)
If you use Fika multiplayer mod, copy from `<SPT_PATH>/BepInEx/plugins/`:
- `Fika.Core.dll`

## Quick Copy Script

You can use this PowerShell script to copy all required files automatically:

```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$SPTPath
)

$ReferencesPath = ".\References"

# Create directories if they don't exist
New-Item -ItemType Directory -Force -Path "$ReferencesPath\BepInEx"
New-Item -ItemType Directory -Force -Path "$ReferencesPath\SPT"
New-Item -ItemType Directory -Force -Path "$ReferencesPath\Game"
New-Item -ItemType Directory -Force -Path "$ReferencesPath\Fika"

# Copy BepInEx libraries
Copy-Item "$SPTPath\BepInEx\core\BepInEx.dll" "$ReferencesPath\BepInEx\"
Copy-Item "$SPTPath\BepInEx\core\0Harmony.dll" "$ReferencesPath\BepInEx\"

# Copy SPT libraries
Copy-Item "$SPTPath\BepInEx\plugins\spt\spt-core.dll" "$ReferencesPath\SPT\"
Copy-Item "$SPTPath\BepInEx\plugins\spt\spt-reflection.dll" "$ReferencesPath\SPT\"

# Copy Game libraries
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
        Write-Host "Copied $lib"
    } else {
        Write-Warning "Library not found: $lib"
    }
}

# Try to copy Fika (optional)
$fikaPath = "$SPTPath\BepInEx\plugins\Fika.Core.dll"
if (Test-Path $fikaPath) {
    Copy-Item $fikaPath "$ReferencesPath\Fika\"
    Write-Host "Copied Fika.Core.dll"
} else {
    Write-Host "Fika.Core.dll not found (optional dependency)"
}

Write-Host "Library setup complete!"
```

Save this script as `CopyLibraries.ps1` and run it with:
```powershell
.\CopyLibraries.ps1 -SPTPath "C:\Path\To\Your\SPT\Installation"
```

## After Copying Libraries

Once you've copied all the required libraries to the `References` folder:

1. The project files have been updated to use local references
2. Run `.\Build.ps1` to build the project
3. The build should complete without requiring an SPT installation path

## Folder Structure

After setup, your `References` folder should look like:
```
References/
├── BepInEx/
│   ├── BepInEx.dll
│   └── 0Harmony.dll
├── SPT/
│   ├── spt-core.dll
│   └── spt-reflection.dll
├── Game/
│   ├── Assembly-CSharp.dll
│   ├── Comfort.dll
│   ├── DissonanceVoip.dll
│   ├── Newtonsoft.Json.dll
│   ├── UnityEngine.dll
│   ├── UnityEngine.CoreModule.dll
│   ├── UnityEngine.UI.dll
│   ├── UnityEngine.AudioModule.dll
│   ├── Unity.TextMeshPro.dll
│   ├── Sirenix.Serialization.dll
│   ├── UnityEngine.InputLegacyModule.dll
│   ├── UnityEngine.JSONSerializeModule.dll
│   ├── UnityEngine.IMGUIModule.dll
│   ├── UnityEngine.PhysicsModule.dll
│   ├── UnityEngine.TerrainModule.dll
│   ├── UnityEngine.TextRenderingModule.dll
│   └── ItemComponent.Types.dll
└── Fika/ (optional)
    └── Fika.Core.dll
```
