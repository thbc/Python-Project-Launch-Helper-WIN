@echo off
REM Usage: open_vscode_env.bat [project folder]
if "%~1"=="" (
    set /p folderPath=Enter the path to your project folder: 
) else (
    set folderPath=%~1
)

powershell -ExecutionPolicy Bypass -File "%~dp0open_and_manage_venv.ps1" -FolderPath "%folderPath%"
PAUSE