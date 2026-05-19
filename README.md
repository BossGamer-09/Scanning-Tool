# BlightVeil Deposit Scanner

AI-powered ore scanning overlay for Star Citizen. Point it at the signature code on your HUD and it instantly identifies the deposit type, value tier, and mineral composition.

[![GitHub release](https://img.shields.io/github/v/release/FrozenButton/Scanning-Tool)](https://github.com/FrozenButton/Scanning-Tool/releases)
[![GitHub stars](https://img.shields.io/github/stars/FrozenButton/Scanning-Tool)](https://github.com/FrozenButton/Scanning-Tool/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/FrozenButton/Scanning-Tool)](https://github.com/FrozenButton/Scanning-Tool/issues)

## What it does
- Captures the HUD deposit signature code, reads it with the `qwen2.5vl:3b` AI model, and shows the deposit type and quantity.
- Locks to a user-selected HUD anchor so the capture box follows head sway and ship movement.
- Hosts a small web overlay (desktop + mobile friendly) so you can view the latest scan from a browser; a GUI button opens it for you.

## Requirements
- **Windows 10/11** (64-bit) or modern 64-bit Linux
- **Python 3.8+** installed and on PATH — download from [python.org](https://www.python.org/downloads/) (tick *Add Python to PATH*)
- **[Ollama](https://ollama.com/)** — AI backend for reading the screen
- GPU with ~2 GB free VRAM (uses ~1.73 GB) or CPU fallback
- 32 GB system RAM recommended when running Star Citizen alongside the scanner

## Quick start

### Windows (recommended)
1. Download the latest release or clone this repo.
2. Double-click `launch_windows.bat`.
3. On first run it creates a virtual environment and installs all dependencies automatically. The scanner then starts and auto-pulls the AI model (~2 GB) if not already present.

> If you'd rather skip Python entirely, grab the pre-built `BlightVeilScanner.exe` from the [Releases](https://github.com/FrozenButton/Scanning-Tool/releases) page — only Ollama is required.

### Linux
1. Download/clone the repo and open a terminal in the folder.
2. Run `./launch_linux.sh` (make executable if needed: `chmod +x launch_linux.sh`).
3. Follow any prompts. Ollama is auto-started the same way as on Windows.

## Ollama setup
- **Same PC (default):** Install Ollama from [ollama.com](https://ollama.com/). The scanner connects to `http://127.0.0.1:11434` and starts the service automatically when needed.
- **Remote PC:** On the Ollama machine set `OLLAMA_HOST=0.0.0.0` and open firewall port 11434. In the scanner GUI enter the remote host (e.g. `http://192.168.1.42:11434`) under **Ollama Connection → Apply Host**.

## Using the scanner
- **Positioning:** Use the capture sliders to place the red box over the deposit code. Toggle visibility with `8`.
- **Anchor alignment:** Place the cyan anchor frame over a stable HUD icon. Load templates from `assets/anchor_templates/`, click **Realign Now**, and tweak offsets until the capture locks on target. Auto-alignment runs before each scan when enabled.
- **Scanning:**
  - `7` — single scan
  - `Ctrl+7` — start / stop continuous scan (interval set by slider)
  - `8` — show / hide capture box
  - Use **Single Scan** / **Loop Toggle** buttons if hotkeys are blocked.
- **Web overlay:** When the app starts it prints links like `http://127.0.0.1:5000` and `http://LAN_IP:5000`. Click **Open Mobile Overlay** to launch your browser. The page auto-refreshes with each scan and includes a Stanton / Pyro system toggle.

## Ore tiers (4.x base codes)

| Tier | Colour | Ores |
|---|---|---|
| Legendary | Gold | Quantanium (3170), Stileron (3185), Savrilium (3200) |
| Epic | Orange | Ouratite (3370), Riccite (3385), Lindinium (3400) |
| Rare | Purple | Beryl (3540), Taranite (3555), Borase (3570), Gold (3585), Bexalite (3600) |
| Uncommon | Green | Laranite (3825), Aslarite (3840), Titanium (3855), Tungsten (3870), Agricium (3885), Torite (3900) |
| Common | Blue | Hephaestanite (4180), Tin (4195), Quartz (4210), Corundum (4225), Copper (4240), Silicon (4255), Iron (4270), Aluminum (4285), Ice (4300) |

Base codes are multiplied by deposit count (1–6). The scanner resolves any valid product back to the rarest matching ore.

## Building the exe
Run `build_exe.bat`. It installs PyInstaller into the project venv (created by `launch_windows.bat`) and produces `dist\BlightVeilScanner.exe`. The venv must exist first — run the launch script at least once before building.

## Troubleshooting
- **Python not found:** Install Python 3.8+ from [python.org](https://www.python.org/downloads/) and tick *Add Python to PATH*.
- **Dependency errors:** Delete the `venv\` folder and re-run `launch_windows.bat` to rebuild it cleanly.
- **Ollama missing:** Install from [ollama.com](https://ollama.com/), then relaunch.
- **Remote Ollama unreachable:** Confirm LAN IP, port 11434, and that `OLLAMA_HOST=0.0.0.0` is set on the remote machine.
- **Hotkeys blocked:** Use the on-screen buttons instead.
- **Windows Defender flags the exe:** Common false positive with PyInstaller builds. Build from source using `build_exe.bat` if preferred.

## Contributing
File issues or feature requests on [GitHub Issues](https://github.com/FrozenButton/Scanning-Tool/issues). PRs welcome — include a short description and testing steps.

Happy mining!
