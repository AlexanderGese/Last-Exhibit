#!/usr/bin/env bash
# Last Exhibit — multi-platform export driver.
# Requires: godot 4.6 in PATH, export templates 4.6.stable installed.
#
# Usage:
#   ./build.sh             # build all four presets
#   ./build.sh web         # build a single preset
#   ./build.sh linux windows
set -euo pipefail

cd "$(dirname "$0")"

if [ -z "${GODOT:-}" ]; then
  GODOT=(flatpak run org.godotengine.Godot)
else
  # shellcheck disable=SC2206
  GODOT=($GODOT)
fi

mkdir -p build/web build/linux build/windows build/macos

build_web() {
  echo "==> Web"
  "${GODOT[@]}" --headless --export-release "Web" build/web/index.html
}

build_linux() {
  echo "==> Linux x86_64"
  "${GODOT[@]}" --headless --export-release "Linux" build/linux/LastExhibit.x86_64
  chmod +x build/linux/LastExhibit.x86_64 || true
}

build_windows() {
  echo "==> Windows x86_64"
  "${GODOT[@]}" --headless --export-release "Windows Desktop" build/windows/LastExhibit.exe
}

build_macos() {
  echo "==> macOS universal"
  "${GODOT[@]}" --headless --export-release "macOS" build/macos/LastExhibit.zip
}

targets=("$@")
if [ ${#targets[@]} -eq 0 ]; then
  targets=(web linux windows macos)
fi

for t in "${targets[@]}"; do
  case "$t" in
    web)     build_web ;;
    linux)   build_linux ;;
    windows|win) build_windows ;;
    macos|mac)   build_macos ;;
    *) echo "Unknown target: $t" >&2; exit 2 ;;
  esac
done

echo
echo "Done. Artifacts:"
find build -maxdepth 2 -type f | sort
