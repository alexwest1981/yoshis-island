#!/bin/sh
# Installs Yoshi's Island into ~/.local/opt/yoshis-island and adds it to the
# application menu. Run from the extracted directory: ./install.sh
set -eu
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PREFIX="$HOME/.local/opt/yoshis-island"

MIN_GLIBC=2.43
have=$(ldd --version 2>/dev/null | head -1 | grep -o '[0-9][0-9]*\.[0-9][0-9]*$')
if [ -n "$have" ] && [ "$(printf '%s\n%s\n' "$MIN_GLIBC" "$have" | sort -V | head -1)" != "$MIN_GLIBC" ]; then
  echo "This build needs glibc >= $MIN_GLIBC (you have $have)." >&2
  echo "Either update the system, or build from source on this machine." >&2
  exit 1
fi

mkdir -p "$PREFIX/lib" "$PREFIX/saves"
install -m755 "$HERE/YoshisIslandRecomp" "$PREFIX/YoshisIslandRecomp"
install -m644 "$HERE/config.ini" "$HERE/keybinds.ini" "$PREFIX/"
install -m644 "$HERE/splash.bmp" "$PREFIX/splash.bmp"
[ -f "$HERE/splash.mp3" ] && install -m644 "$HERE/splash.mp3" "$PREFIX/splash.mp3"
[ -f "$HERE/lib/libSDL2-2.0.so.0" ] && install -m644 "$HERE/lib/libSDL2-2.0.so.0" "$PREFIX/lib/"
[ -f "$HERE/yoshis-island.sfc" ] && install -m644 "$HERE/yoshis-island.sfc" "$PREFIX/rom.sfc"

if [ ! -f "$PREFIX/rom.sfc" ]; then
  echo "No ROM in this package. Put your own headerless dump here:" >&2
  echo "  $PREFIX/rom.sfc   (2,097,152 bytes)" >&2
fi

cat > "$PREFIX/yoshis-island" <<'LAUNCH'
#!/bin/sh
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec env LD_LIBRARY_PATH="$HERE/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
  "$HERE/YoshisIslandRecomp" --rom "$HERE/rom.sfc" "$@"
LAUNCH
chmod 755 "$PREFIX/yoshis-island"

mkdir -p "$HOME/.local/share/applications" "$HOME/.local/share/icons/hicolor/256x256/apps"
[ -f "$HERE/icon.png" ] &&
  install -m644 "$HERE/icon.png" "$HOME/.local/share/icons/hicolor/256x256/apps/yoshis-island.png"

cat > "$HOME/.local/share/applications/yoshis-island.desktop" <<DESK
[Desktop Entry]
Type=Application
Name=Yoshi's Island
Comment=Super Mario World 2 — native build (not an emulator)
Exec=$PREFIX/yoshis-island
Icon=yoshis-island
Terminal=false
Categories=Game;ActionGame;
StartupNotify=false
DESK

command -v update-desktop-database >/dev/null 2>&1 &&
  update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo "installed: $PREFIX"
echo "start it from the application menu, or run: $PREFIX/yoshis-island"
[ -f "$PREFIX/rom.sfc" ] || echo "remember to add rom.sfc (see above)"
