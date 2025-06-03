# Python-Project-Launch
A helper for starting a python project in VSCode or VSCodium in virtual environment - in Windows.
## How to use
1. Place the folder anywhere you like.
2. Create a shortcut for the open_vscode_env.bat file, e.g. on Desktop.
3. Click the shortcut > opens the terminal. Now paste the path to your project folder where a python file is located.
4. Create or load a .venv for installing the project's packages.


## Change from VSCode to VSCodium
In the line "Start-Process code -ArgumentList "." -Wait" change "Start-Process code" to "Start-Process codium. Now it should open the project in your VSCodium installation.
