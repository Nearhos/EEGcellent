@echo off
echo 🚀 Starting EEGcellent Website Server...
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed or not in PATH
    echo Please install Python from https://python.org
    pause
    exit /b 1
)

REM Check if Flask is installed
python -c "import flask" >nul 2>&1
if errorlevel 1 (
    echo 📦 Installing Flask...
    pip install flask
    if errorlevel 1 (
        echo ❌ Failed to install Flask
        pause
        exit /b 1
    )
)

echo ✅ Starting server...
echo.
python server.py

pause 