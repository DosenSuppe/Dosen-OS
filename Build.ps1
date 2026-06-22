param(
    [string]$o = "os.o", # output filename

    [switch]$b,
    [switch]$t
)

if ($b -and $t) {
    Write-Error "Error: You cannot specify both -b (binary) and -t (text) at the same time."
    exit 1
}

# Default output is the Emulator's C32R sparse binary. The legacy Logisim text
# format is kept only for debugging via -t.
$OutputAsBinary = $true
if ($t) {
    $OutputAsBinary = $false
}

$SrcDirectory = Join-Path $PSScriptRoot "src"
if (-not (Test-Path $SrcDirectory)) {
    Write-Error "Error: 'src' directory not found at $SrcDirectory"
    exit 1
}

# --- Toolchain selection ----------------------------------------------------
# Prefer the toolchain SOURCE (run via the project venv) over the installed
# dasm-*.exe shims. The exes in C:\Program Files\dasm are PyInstaller snapshots
# that can lag behind DevTools source — notably the WordConfig word-width /
# addressing settings. Running from source keeps the build in lockstep with the
# toolchain while the 32-bit port is in flight. Falls back to the exes only if
# the venv isn't present.
$DevTools = Join-Path $PSScriptRoot "..\CPU-24bit\DevTools"
$Python   = Join-Path $PSScriptRoot "..\CPU-24bit\.venv\Scripts\python.exe"
$UseSource = (Test-Path $Python) -and (Test-Path $DevTools)

if ($UseSource) {
    Write-Host "Toolchain: source (DevTools via venv)"
} else {
    Write-Host "Toolchain: installed dasm-*.exe (venv not found at $Python)"
}

function Invoke-Cc {
    param([string]$File)
    if ($UseSource) { & $Python (Join-Path $DevTools "CCompiler.py") $File --no-entry --silent }
    else            { dasm-cc $File --no-entry --silent }
}

function Invoke-Asm {
    param([string]$File)
    if ($UseSource) { & $Python (Join-Path $DevTools "Compiler.py") $File }
    else            { dasm $File }
}

function Invoke-Link {
    param([string]$Flag, [string]$Obj, [string]$Cfg, [string]$Out)
    if ($UseSource) { & $Python (Join-Path $DevTools "Linker.py") $Flag $Obj $Cfg $Out }
    else            { dasm-linker $Flag $Obj $Cfg $Out }
}

Write-Host "Compiling C-Code..."
$CFiles = Get-ChildItem -Path $SrcDirectory -Filter *.c -Recurse

if ($CFiles.Count -eq 0) {
    Write-Warning "No .c files found in $SrcDirectory or its subfolders."
} else {
    foreach ($File in $CFiles) {
        Write-Host "Compiling: $($File.Name)"
        Invoke-Cc $File.FullName
        if ($LASTEXITCODE -ne 0) {
            Write-Error "C compile FAILED for $($File.Name). Build halted (the image would be stale)."
            exit 1
        }
    }
}

Write-Host "Compiling ./src/main.asm ..."
Invoke-Asm (Join-Path $PSScriptRoot "src\main.asm")
if ($LASTEXITCODE -ne 0) {
    Write-Error "Assembly FAILED. Build halted: the linker would otherwise reuse stale .obj files and your changes would NOT appear in the image."
    exit 1
}

Write-Host "Output file will be saved as: $o"

if ($OutputAsBinary) {
    Write-Host "Writing ROM as C32R sparse binary..."
    Invoke-Link "-b" ".\bin\main.obj" ".\mem.cfg" ".\$o"
} else {
    Write-Host "Writing ROM in legacy Logisim text format..."
    Invoke-Link "-t" ".\bin\main.obj" ".\mem.cfg" ".\$o"
}

$FileGenerated = Test-Path "$PSScriptRoot\$o"

if (-not ($FileGenerated)) {
    Write-Error "Image was not generated!"
    exit 1
}

Write-Host "Project compiled and image generated at $o"
