@echo off
setlocal enabledelayedexpansion

echo === Star Citizen Scanning Tool - Windows Setup ===

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "VENV_DIR=%SCRIPT_DIR%\venv"
set "VENV_PYTHON=%VENV_DIR%\Scripts\python.exe"
set "VENV_PIP=%VENV_DIR%\Scripts\pip.exe"

echo Script directory: %SCRIPT_DIR%

REM ── Find a working system Python ──────────────────────────────────────────
set "SYSTEM_PYTHON="

REM Try the Windows 'py' launcher first (most reliable on Windows)
py --version >nul 2>&1
if not errorlevel 1 (
    set "SYSTEM_PYTHON=py"
    goto :python_found
)

REM Fall back to 'python' on PATH
python --version >nul 2>&1
if not errorlevel 1 (
    set "SYSTEM_PYTHON=python"
    goto :python_found
)

echo ERROR: No Python installation found.
echo Please install Python 3.8+ from https://www.python.org/downloads/
echo Make sure to tick "Add Python to PATH" during installation.
pause
exit /b 1

:python_found
for /f "tokens=*" %%v in ('!SYSTEM_PYTHON! --version 2^>^&1') do echo Found: %%v

REM ── Create virtual environment if it doesn't exist ─────────────────────────
if not exist "%VENV_PYTHON%" (
    echo Creating virtual environment...
    "!SYSTEM_PYTHON!" -m venv "%VENV_DIR%"
    if errorlevel 1 (
        echo ERROR: Failed to create virtual environment.
        echo Make sure Python includes the 'venv' module ^(standard in Python 3.3+^).
        pause
        exit /b 1
    )
    echo Virtual environment created at: %VENV_DIR%
) else (
    echo Virtual environment already exists at: %VENV_DIR%
)

REM ── Install / update requirements ─────────────────────────────────────────
set "REQ_MARKER=%VENV_DIR%\.requirements_installed"
set "INSTALL_REQUIRED=0"

if not exist "%REQ_MARKER%" set "INSTALL_REQUIRED=1"

if exist "%REQ_MARKER%" (
    for %%i in ("%SCRIPT_DIR%\requirements.txt") do set "REQ_DATE=%%~ti"
    for %%i in ("%REQ_MARKER%") do set "MARKER_DATE=%%~ti"
    if "!REQ_DATE!" GTR "!MARKER_DATE!" set "INSTALL_REQUIRED=1"
)

if !INSTALL_REQUIRED!==1 (
    echo Upgrading pip...
    "%VENV_PIP%" install --upgrade pip
    echo Installing Python requirements...
    "%VENV_PIP%" install -r "%SCRIPT_DIR%\requirements.txt"
    if errorlevel 1 (
        echo ERROR: Failed to install one or more requirements.
        pause
        exit /b 1
    )
    echo. > "%REQ_MARKER%"
    echo Requirements installed successfully.
) else (
    echo Requirements already up to date.
)

REM ── Check Ollama ──────────────────────────────────────────────────────────
where ollama >nul 2>&1
if errorlevel 1 (
    echo.
    echo WARNING: Ollama is not installed^^!
    echo The application will prompt you to install it from https://ollama.com/
    echo For Windows, download the installer from the official website.
    echo.
)

REM ── Launch ────────────────────────────────────────────────────────────────
echo Launching Star Citizen Scanning Tool...
echo Press Ctrl+C to stop the application
echo.

cd /d "%SCRIPT_DIR%"
"%VENV_PYTHON%" scan_deposits.py
set "EXIT_CODE=%ERRORLEVEL%"

echo.
echo Application closed.

if "%EXIT_CODE%"=="0" (
    exit /b 0
) else (
    echo Application exited with error %EXIT_CODE%.
    timeout /t 8 >nul
    exit /b %EXIT_CODE%
)
