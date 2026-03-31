# -*- mode: python ; coding: utf-8 -*-
from PyInstaller.utils.hooks import collect_submodules
from PyInstaller.utils.hooks import collect_all

datas = [('templates', 'templates'), ('assets', 'assets'), ('RockTypes_2025-09-16.json', '.')]
binaries = []
hiddenimports = ['mss.windows', 'mss.base', 'PIL.Image', 'PIL.ImageDraw', 'PIL.ImageTk', 'PIL._imaging', 'keyboard._winkeyboard', 'tkinter', 'tkinter.ttk', 'tkinter.colorchooser', 'tkinter.messagebox', 'logging.handlers', 'urllib.parse']
hiddenimports += collect_submodules('anyio')
hiddenimports += collect_submodules('sniffio')
tmp_ret = collect_all('ollama')
datas += tmp_ret[0]; binaries += tmp_ret[1]; hiddenimports += tmp_ret[2]
tmp_ret = collect_all('flask')
datas += tmp_ret[0]; binaries += tmp_ret[1]; hiddenimports += tmp_ret[2]
tmp_ret = collect_all('werkzeug')
datas += tmp_ret[0]; binaries += tmp_ret[1]; hiddenimports += tmp_ret[2]
tmp_ret = collect_all('httpx')
datas += tmp_ret[0]; binaries += tmp_ret[1]; hiddenimports += tmp_ret[2]


a = Analysis(
    ['scan_deposits.py'],
    pathex=[],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=['matplotlib', 'scipy', 'pandas', 'pytest', 'IPython', 'notebook', 'sphinx'],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='BlightVeilMiner',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['assets\\BlightVeil.ico'],
)
