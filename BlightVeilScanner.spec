# BlightVeil Scanner - PyInstaller spec
# Build with:  pyinstaller BlightVeilScanner.spec --clean --noconfirm
#
# Produces a single BlightVeilScanner.exe in the dist\ folder.
# config.json, log files, and assets\anchor_templates\ are intentionally
# NOT bundled so users can edit/add to them next to the exe.

from PyInstaller.utils.hooks import collect_all, collect_submodules

# Pull in every submodule of packages that use dynamic imports or
# have complex plugin structures that PyInstaller can miss.
ollama_datas,   ollama_bins,   ollama_hidden   = collect_all('ollama')
flask_datas,    flask_bins,    flask_hidden     = collect_all('flask')
werkzeug_datas, werkzeug_bins, werkzeug_hidden  = collect_all('werkzeug')
httpx_datas,    httpx_bins,    httpx_hidden     = collect_all('httpx')

block_cipher = None

a = Analysis(
    ['scan_deposits.py'],
    pathex=[],
    binaries=[
        *ollama_bins,
        *flask_bins,
        *werkzeug_bins,
        *httpx_bins,
    ],
    datas=[
        # App resources (read via resource_path / sys._MEIPASS at runtime)
        ('templates',                   'templates'),
        ('assets/BlightVeil.ico',       'assets'),
        ('assets/BlightVeilBanner.png', 'assets'),
        ('RockTypes_2025-09-16.json',   '.'),
        # Package data
        *ollama_datas,
        *flask_datas,
        *werkzeug_datas,
        *httpx_datas,
    ],
    hiddenimports=[
        # Package hidden submodules
        *ollama_hidden,
        *flask_hidden,
        *werkzeug_hidden,
        *httpx_hidden,
        *collect_submodules('anyio'),
        *collect_submodules('sniffio'),
        # mss Windows backend
        'mss.windows',
        'mss.base',
        # Pillow
        'PIL.Image',
        'PIL.ImageDraw',
        'PIL.ImageTk',
        'PIL._imaging',
        # Keyboard Windows backend
        'keyboard._winkeyboard',
        # Tkinter (bundled with CPython on Windows but explicit is safer)
        'tkinter',
        'tkinter.ttk',
        'tkinter.colorchooser',
        'tkinter.messagebox',
        # Stdlib
        'logging.handlers',
        'urllib.parse',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    # Strip heavy packages that will never be imported
    excludes=[
        'matplotlib', 'scipy', 'pandas', 'pytest',
        'IPython', 'notebook', 'sphinx',
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='BlightVeilScanner',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    # UPX compresses the exe if UPX is installed; silently skipped if not.
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    # console=True keeps the startup/log window visible so users can see
    # Ollama status and any errors on first run.
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='assets/BlightVeil.ico',
)
