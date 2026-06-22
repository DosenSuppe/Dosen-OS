# BuildProgram.ps1 — assemble, link, and pack a disk-loadable Dosen-OS program,
# then drop it into the host PermStorage folder so `run <name>` can load it.
#
# Unlike Build.ps1 (which builds the whole OS image), this builds a single
# standalone program that lives on "disk" and is loaded at runtime. See
# docs/Writing-Programs.md (Packed disk-program format).
#
#   .\BuildProgram.ps1 -Source .\userland\hello.dasm
#   .\BuildProgram.ps1 -Source .\userland\hello.dasm -Name hello -OutDir ..\PermStorage

param(
    [Parameter(Mandatory = $true)]
    [string]$Source,                       # path to the program .dasm

    [string]$Name,                         # output filename in PermStorage (default: source base name)
    [string]$OutDir = "..\PermStorage",    # host PermStorage folder
    [string]$Cfg = ".\userland\program.cfg",
    [int]$Entry = 0                        # entry offset within the body (words)
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Source)) { Write-Error "Source not found: $Source"; exit 1 }
if (-not (Test-Path $Cfg))    { Write-Error "Link config not found: $Cfg"; exit 1 }

if (-not $Name) { $Name = [System.IO.Path]::GetFileNameWithoutExtension($Source) }

# Locate the toolchain's DevTools + venv python relative to this repo.
$DevTools = Join-Path $PSScriptRoot "..\CPU-24bit\DevTools"
$Python   = Join-Path $PSScriptRoot "..\CPU-24bit\.venv\Scripts\python.exe"
if (-not (Test-Path $Python)) { $Python = "python" }   # fall back to PATH

# Assemble the program to its own object file under bin/userland/.
$ObjDir  = Join-Path $PSScriptRoot "bin\userland"
if (-not (Test-Path $ObjDir)) { New-Item -ItemType Directory -Force -Path $ObjDir | Out-Null }
$ObjBase = Join-Path $ObjDir $Name

Write-Host "Assembling $Source ..."
dasm $Source $ObjBase
$ObjFile = "$ObjBase.obj"
if (-not (Test-Path $ObjFile)) { Write-Error "Assembly produced no object: $ObjFile"; exit 1 }

# Ensure the output folder exists, then pack.
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Force -Path $OutDir | Out-Null }
$OutFile = Join-Path $OutDir $Name

Write-Host "Packing -> $OutFile ..."
& $Python (Join-Path $PSScriptRoot "tools\PackProgram.py") `
    --obj $ObjFile `
    --cfg $Cfg `
    --out $OutFile `
    --segment "Program" `
    --base "0x01500000" `
    --entry "$Entry" `
    --devtools $DevTools
if ($LASTEXITCODE -ne 0) { Write-Error "Packing failed."; exit 1 }

Write-Host ""
Write-Host "Done. Program '$Name' is in $OutDir."
Write-Host "Boot the OS and run it with:  run $Name"
