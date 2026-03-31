# BlightVeil Scanner

AI-powered ore scanning overlay for Star Citizen. Point it at the signature code on your HUD and it instantly identifies the deposit type, value tier, and mineral composition.

---

## Requirements

- **Windows 10 / 11** (64-bit)
- **[Ollama](https://ollama.com/)** — the AI backend that reads the screen

That's it. No Python installation needed.

---

## First-Time Setup

### 1. Install Ollama
Download and install from **https://ollama.com/**

Run the installer and leave Ollama running in the system tray. You do not need to do anything else — the scanner will download the AI model automatically on first launch.

### 2. Run BlightVeilScanner.exe
Double-click the exe. A console window will open showing startup progress:

```
Ollama found: ollama version is X.X.X
Local Ollama service detected.
Model moondream2 not found — Pulling now...   ← first run only, ~1.7 GB
Model installed successfully.
Hotkeys registered...
```

The control panel GUI will open once setup is complete. The **first launch takes longer** because it downloads the AI model (~2 GB). Subsequent launches are fast.

---

## Files Created on First Run

After launching, the following are created next to the exe automatically:

| File / Folder | Purpose |
|---|---|
| `config.json` | Saved settings (capture region, overlay position, etc.) |
| `scanning_tool.log` | Application log — useful for troubleshooting |
| `flask_access.log` | Web overlay access log |
| `assets\anchor_templates\` | Drop your head-sway template images here |

---

## How to Use

### Step 1 — Position the capture region
The red box on your screen shows where the scanner is reading. Use the **Capture Region** sliders in the control panel to move and resize it so the red box sits exactly over the signature code in your Star Citizen HUD.

Click **Update Overlay** any time you move sliders to refresh the overlay positions.

### Step 2 — Scan
| Action | How |
|---|---|
| Single scan | Press `7` or click **Single Scan** |
| Continuous scanning | Press `Ctrl+7` or click **Start Loop** |
| Stop continuous | Press `Ctrl+7` again or click **Stop Loop** |
| Toggle red border | Press `8` or click **Toggle Border** |

The identified ore name appears as a floating label on your screen in real time.

### Step 3 — Save your settings
Click **Save Config** after adjusting sliders. Settings are restored automatically next time you launch.

---

## Web Overlay (Phone / Tablet)

The scanner hosts a web page on your local network showing the current scan result, mineral composition table, and scan history.

1. In the control panel click **Open Mobile UI** — your browser opens to the local address
2. On your phone or tablet open the same address shown in the console:
   ```
   http://192.168.x.x:5000
   ```
3. Keep the page open while you play — it updates every half second automatically

The Stanton / Pyro toggle on the web page switches the mineral composition data to the correct system.

---

## Head Sway Compensation

The scanner can automatically adjust the capture region when your character's head moves in-game (head sway), keeping it locked on the correct HUD element.

### Setup
1. Take a screenshot of a stable part of your HUD that does not move relative to the scan code (e.g. a static icon or frame element near the signature display)
2. Crop out just that element and save it as a `.png` or `.jpg`
3. Drop the image into `assets\anchor_templates\` next to the exe
4. Click **Reload Templates** in the control panel

Once templates are loaded, enable **Enable auto alignment** in the Head Sway Compensation section. The status bar will show `Locked XX%` when the anchor is found.

### Tuning
- **Detection threshold** — raise it (closer to 1.0) if it locks onto the wrong thing; lower it if it fails to lock
- **Alignment interval** — how often it checks (ms). 500ms is a good default

---

## Remote Ollama (Advanced)

If you run Ollama on a different PC on your network (e.g. a gaming PC with no Python):

1. In the control panel find **Ollama Connection**
2. Enter the host IP and port: `http://192.168.x.x:11434`
3. Click **Apply Host**

Leave the field blank to use the local installation.

---

## Ore Value Tiers

| Tier | Colour | Examples |
|---|---|---|
| Highest | Purple | Quantanium, Stileron, Savrilium |
| High | Green | Taranite, Bexalite, Gold, Beryl |
| Medium | Yellow | Laranite, Agricium, Hephaestanite |
| Low | Orange | Tungsten, Titanium, Iron, Ice |

---

## Troubleshooting

**The scanner always shows the wrong ore / random numbers**
The capture region is not on the signature code. Reposition the red box using the Capture Region sliders. The scan code in Star Citizen is the 4–5 digit number shown during active scanning.

**"Ollama not found" on startup**
Install Ollama from https://ollama.com/ and make sure it is running before launching the scanner.

**Model download is stuck or failed**
Check your internet connection and try again. The model (`qwen2.5vl:3b`) is ~2 GB. You can also pull it manually by running `ollama pull qwen2.5vl:3b` in a terminal.

**The overlay text does not appear**
Click **Update Overlay** in the control panel, or try dragging the control panel window to force a redraw.

**Hotkeys not working**
The `keyboard` library requires the scanner to run with standard user permissions. Do not run as Administrator — it can prevent global hotkeys from registering in some setups.

**Windows Defender flags the exe**
This is a false positive common with PyInstaller-built executables. The source code is fully open — build the exe yourself from `scan_deposits.py` using `build_exe.bat` if you prefer.

---

## Configuration Reference

`config.json` is created next to the exe on first run. You can edit it in any text editor.

| Key | Description |
|---|---|
| `CAP_REGION` | Pixel coordinates of the scan capture box |
| `ANCHOR_REGION` | Area searched for head-sway anchor templates |
| `ANCHOR_OFFSET` | Pixel offset from anchor match to capture region |
| `ANCHOR_THRESHOLD` | Match confidence required (0.1–0.99, default 0.82) |
| `AUTO_ALIGN_ENABLED` | Enable/disable head sway compensation |
| `ALIGNMENT_POLL_INTERVAL_MS` | How often alignment runs (ms) |
| `CONTINUOUS_CAPTURE_INTERVAL` | Seconds between scans in loop mode |
| `INFO_OVERLAY_OFFSET` | X/Y pixel offset for the floating result label |
| `label_color` | Hex colour of the floating result label |
| `OLLAMA_HOST` | Remote Ollama URL (blank = use local) |
