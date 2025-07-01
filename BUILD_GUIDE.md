# Building That's Lit for SPT 3.11.x

## Prerequisites

1. **Visual Studio 2022** or **Visual Studio Code** with C# extension
2. **.NET Framework 4.8 Developer Pack**
3. **SPT 3.11.x installation** (for copying required libraries)
4. **PowerShell** (for build scripts)

## Quick Setup

### Step 1: Copy Required Libraries

The project now uses local references instead of requiring an SPT installation path. You need to copy the required libraries once:

```powershell
# Run this command from the project root directory
.\CopyLibraries.ps1 -SPTPath "C:\Path\To\Your\SPT\Installation"
```

This will copy all required libraries to the `References` folder. See `LIBRARY_SETUP.md` for detailed information about required libraries.

### Step 2: Build the Project

```powershell
# Build both plugins
.\Build.ps1
```

The build script will:
- Verify all required libraries are present
- Clean previous builds
- Restore NuGet packages
- Build both Core and Sync plugins
- Copy output to the configured SPT plugins directory (if EFTPath is set)

## Manual Setup (Alternative)

If you prefer not to use the automated scripts:
### 1. Manual Library Setup

Copy the required libraries to the `References` folder as described in `LIBRARY_SETUP.md`:

- `References\BepInEx\` - BepInEx.dll, 0Harmony.dll
- `References\SPT\` - spt-core.dll, spt-reflection.dll  
- `References\Game\` - Assembly-CSharp.dll, Unity assemblies, etc.

### 2. Build Process

#### Option A: Visual Studio (Recommended)
1. Open `ThatsLit.sln` in Visual Studio
2. Set the configuration to **Release**
3. Build → Build Solution (Ctrl+Shift+B)

#### Option B: Command Line
```powershell
# Clean old artifacts (optional)
.\CleanupFor311.ps1

# Build the solution
dotnet build ThatsLit.sln --configuration Release
```

#### Option C: Visual Studio Code
1. Open the project folder in VS Code
2. Press `Ctrl+Shift+P` and run: `.NET: Build`
3. Select **Release** configuration

## Build Output

When successful, the build will:
- Generate `ThatsLit.Core.dll` and `ThatsLit.Sync.dll`
- Automatically copy assemblies to your SPT installation
- Copy compatibility files from the `Packed` folder

**Output Locations:**
- `ThatsLit.Core\bin\Release\net48\ThatsLit.Core.dll`
- `ThatsLit.Sync\bin\Release\net48\ThatsLit.Sync.dll`
- Auto-copied to: `{SPT}\BepInEx\plugins\ThatsLit\`

## Troubleshooting

### Common Issues

#### Assembly Reference Errors
**Problem:** Cannot find BepInEx, Unity, or EFT assemblies
**Solution:** 
1. Verify SPT 3.11.x is properly installed
2. Check `EFTPath` in `.csproj` files points to correct SPT directory
3. Ensure SPT has been launched at least once

#### Target Framework Errors
**Problem:** .NET Framework 4.8 not found
**Solution:** Install .NET Framework 4.8 Developer Pack from Microsoft

#### Build Path Issues
**Problem:** Cannot find project files
**Solution:** Ensure you're running commands from the solution root directory

### Verification Steps

1. **Check SPT Installation:**
   ```powershell
   Test-Path "{Your-SPT-Path}\BepInEx\core\BepInEx.dll"
   Test-Path "{Your-SPT-Path}\BepInEx\plugins\spt\spt-core.dll"
   ```

2. **Verify Build Output:**
   ```powershell
   Test-Path "ThatsLit.Core\bin\Release\net48\ThatsLit.Core.dll"
   Test-Path "ThatsLit.Sync\bin\Release\net48\ThatsLit.Sync.dll"
   ```

3. **Check Installation:**
   ```powershell
   Test-Path "{Your-SPT-Path}\BepInEx\plugins\ThatsLit\ThatsLit.Core.dll"
   ```

## Development Tips

- Use **Release** configuration for distribution
- Use **Debug** configuration for development and testing
- The build automatically copies output to your SPT installation
- Clean build artifacts with `.\CleanupFor311.ps1` if needed
- Monitor SPT logs in `{SPT}\BepInEx\LogOutput.log` for runtime issues

## Build Success Confirmation

A successful build will show:
```
Build succeeded.
    0 Warning(s)
    0 Error(s)
```

And create these files:
- `ThatsLit.Core.dll` (Core functionality)
- `ThatsLit.Sync.dll` (Multiplayer sync)
- Compatibility JSON files
- All automatically copied to SPT plugins directory

You're now ready to test That's Lit with SPT 3.11.x!
