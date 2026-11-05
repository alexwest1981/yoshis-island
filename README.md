# Yoshi's Island — native Linux build

Super Mario World 2: Yoshi's Island (SNES) as a native Linux program: the 65816
game code is statically recompiled to C at build time, no emulator frontend. The
SuperFX (GSU-2) coprocessor, PPU and audio chip are emulated as silicon in C.

Private, personal use. It is a derivative work of a Nintendo game — do not
publish or redistribute it, and do not share the ROM.

## Install on another machine (CachyOS / Arch, x86_64)

```sh
# 1. get the release asset (see Releases on the right)
gh release download v1.0 -R alexwest1981/yoshis-island --pattern '*.tar.gz'

# 2. unpack and install
tar -xzf yoshis-island-linux-x86_64-norom.tar.gz
cd yoshis-island
./install.sh          # -> ~/.local/opt/yoshis-island + application menu entry

# 3. add your own ROM dump (2,097,152 bytes, headerless .sfc)
cp "/path/to/Super Mario World 2 - Yoshi's Island (U) (V1.1).sfc" \
   ~/.local/opt/yoshis-island/rom.sfc

# 4. start it from the app menu, or:
~/.local/opt/yoshis-island/yoshis-island
```

The ROM is not in the release asset on purpose: it is Nintendo's copyrighted
data, and the binary only needs it at runtime. A copier-headered `.smc` works
too (the 512-byte header is stripped), and the build accepts Rev 1.0 as well as
Rev 1.1.

## What it does

* Boot splash (`splash.bmp`) with your own MP3 (`splash.mp3`); stays until a
  button is pressed.
* Four scalers: `nearest`, `linear`, `sharp` (sharp-bilinear), `crt`; optional
  integer scaling for perfectly square pixels and an unsharp-style sharpen.
* Vsync on by default (the loop paces to the SNES's 60.0988 Hz).
* Xbox/PS/Switch pads work alongside the keyboard.
* Saves to `saves/save.srm` next to the executable.

`config.ini` keys: `Shader`, `IntegerScale`, `Sharpen`, `VSync`, `Splash`,
`SplashSeconds` (0 = wait for a button), `SplashMusic`, `DisplayAspect`,
`SourceP1` (0 = keyboard + pad).

## Controls

| Action | Keyboard | Pad |
|---|---|---|
| Move / aim | Arrows or WASD | D-pad / left stick |
| Jump / flutter | J or Space | A |
| Tongue | K or Z | X |
| Throw egg | L or X | B |
| Lock aim | I or C | Y |
| Look left / right | Q / E | LB / RB |
| Start / pause | Enter | Start |
| Item bag | Tab | Back |
| Fullscreen | F11 / Alt+Enter | — |
| Quit | Esc | — |
