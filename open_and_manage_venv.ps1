<#
.SYNOPSIS
    Open a Python project in VSCodium, prompting for folder path, then listing .py files for you to choose, with auto-venv activation/deactivation.
.PARAMETER FolderPath
    (Optional) Path to your project folder.
#>
param(
    [string]$FolderPath
)

# Prompt for folder path if not provided
if ([string]::IsNullOrWhiteSpace($FolderPath)) {
    $FolderPath = Read-Host "Enter the path to your project folder"
}

# Verify folder exists
if (-not (Test-Path -Path $FolderPath -PathType Container)) {
    Write-Error "Folder not found: $FolderPath"
    exit 1
}

# List .py files and have user select
$pyFiles = @(Get-ChildItem -Path $FolderPath -Filter '*.py' | Select-Object -ExpandProperty Name)
if ($pyFiles.Count -eq 0) {
    Write-Error "No Python (*.py) files found in: $FolderPath"
    exit 1
}

Write-Host "Select a Python script to open:" -ForegroundColor Cyan
for ($i = 0; $i -lt $pyFiles.Count; $i++) {
    Write-Host "[$($i+1)]: $($pyFiles[$i])"
}

[int]$selection = 0
while ($selection -lt 1 -or $selection -gt $pyFiles.Count) {
    $selection = Read-Host "Enter number (1-$($pyFiles.Count))"
}

$FileName = $pyFiles[$selection - 1]
$fullPath = Join-Path $FolderPath $FileName | Resolve-Path

# Change into project directory
Push-Location $FolderPath

# Detect, optionally create, and activate virtual environment
if (Test-Path -Path ".venv\Scripts\Activate.ps1" -PathType Leaf) {
    Write-Host "Activating .venv virtual environment..."
    & .\.venv\Scripts\Activate.ps1
} elseif (Test-Path -Path "venv\Scripts\Activate.ps1" -PathType Leaf) {
    Write-Host "Activating venv virtual environment..."
    & .\venv\Scripts\Activate.ps1
} else {
    Write-Host "No virtual environment found."
    $createVenv = Read-Host "Would you like to create a new virtual environment named '.venv'? (Y/N)"
    if ($createVenv -match '^[Yy]') {
        Write-Host "Creating .venv virtual environment..."
        python -m venv .venv
        if (-not (Test-Path -Path ".venv\Scripts\Activate.ps1" -PathType Leaf)) {
            Write-Error "Failed to create .venv. Please check your Python installation."
            exit 1
        }
        Write-Host "Activating new .venv virtual environment..."
        & .\.venv\Scripts\Activate.ps1
    } else {
        Write-Host "Skipping virtual environment creation."
    }
}

# Launch VSCodium and wait until it closes
Write-Host "Opening folder in VSCodium..."
Start-Process codium -ArgumentList "." -Wait

# Deactivate virtual environment if available
if (Get-Command deactivate -ErrorAction SilentlyContinue) {
    Write-Host "Deactivating virtual environment..."
    deactivate
}

# Return to original directory
Pop-Location