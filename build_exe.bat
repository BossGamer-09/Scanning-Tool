@echo off
setlocal enabledelayedexpansion

echo.
echo  =====================================================
echo   BlightVeil Scanner - Build Executable
echo  =====================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

set "VENV_DIR=%SCRIPT_DIR%\venv"
set "VENV_PYTHON=%VENV_DIR%\Scripts\python.exe"
set "VENV_PIP=%VENV_DIR%\Scripts\pip.exe"

REM ── Ensure the venv exists (run launch_windows.bat first if not) ─────────────
if not exist "%VENV_PYTHON%" (
    echo [ERROR] Virtual environment not found at: %VENV_DIR%
    echo         Run launch_windows.bat first to set up the environment.
    pause & exit /b 1
)

for /f "tokens=2" %%v in ('"%VENV_PYTHON%" --version 2^>^&1') do set "PY_VER=%%v"
echo  Python: %PY_VER%

REM ── Install / upgrade PyInstaller into the venv ──────────────────────────────
echo.
echo  Installing / upgrading PyInstaller...
"%VENV_PIP%" install pyinstaller --upgrade --quiet
if errorlevel 1 (
    echo [ERROR] Failed to install PyInstaller.
    pause & exit /b 1
)

REM ── Clean previous build artefacts ───────────────────────────────────────────
echo  Cleaning previous build...
if exist build rmdir /s /q build
if exist dist  rmdir /s /q dist

REM ── Run PyInstaller via the venv Python ──────────────────────────────────────
echo.
echo  Building BlightVeilScanner.exe  (this may take a few minutes)...
echo.
"%VENV_PYTHON%" -m PyInstaller BlightVeilScanner.spec --clean --noconfirm

if errorlevel 1 (
    echo.
    echo  [ERROR] Build failed. Review the output above for details.
    pause & exit /b 1
)

REM ── Success ───────────────────────────────────────────────────────────────────
echo.
echo  =====================================================
echo   Build complete^^!
echo  =====================================================
echo.
echo   Executable : dist\BlightVeilScanner.exe
echo.
echo   When distributing the exe, the end-user only needs:
echo     - BlightVeilScanner.exe
echo     - Ollama installed  (https://ollama.com/)
echo.
echo   The following are created automatically on first run:
echo     - config.json
echo     - scanning_tool.log / flask_access.log
echo     - assets\anchor_templates\  (folder for head-sway templates)
echo.
pause
