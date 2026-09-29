#!/usr/bin/env bash
# Last Exhibit — copy Godot exports into the site and fill the showcases.
#
# Run ../../lastExhibit/build.sh first, then this. For every platform that
# has an export it:
#   - packages it for download (Windows and Linux export the program and its
#     .pck separately, so both go into one zip — the program alone won't run)
#   - records size, date and SHA-256
#   - rewrites assets/js/builds.js, which the page reads at load
# Platforms without an export stay "not in the collection yet".
#
# Usage:
#   ./scripts/sync-builds.sh                    # ../../lastExhibit/build
#   ./scripts/sync-builds.sh /path/to/build     # elsewhere
#   VERSION=0.9.1 ./scripts/sync-builds.sh      # label the release
set -euo pipefail

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GAME_DIR="$(cd "$SITE_DIR/../../lastExhibit" 2>/dev/null && pwd || true)"
BUILD_DIR="${1:-$GAME_DIR/build}"

DOWNLOADS="$SITE_DIR/downloads"
WEB="$SITE_DIR/game"
MANIFEST="$SITE_DIR/assets/js/builds.js"

if [ ! -d "$BUILD_DIR" ]; then
  echo "No build directory at: $BUILD_DIR" >&2
  echo "Run lastExhibit/build.sh first, or pass the path as an argument." >&2
  exit 1
fi

command -v zip >/dev/null || { echo "zip is required" >&2; exit 1; }

TODAY="$(date +%F)"
VERSION="${VERSION:-$(git -C "$GAME_DIR" describe --tags --always 2>/dev/null || echo "")}"

mkdir -p "$DOWNLOADS" "$WEB"

filesize() { stat -c%s "$1" 2>/dev/null || stat -f%z "$1"; }
sha256() {
  if command -v sha256sum >/dev/null; then sha256sum "$1" | cut -d' ' -f1
  else shasum -a 256 "$1" | cut -d' ' -f1; fi
}

# zip_dir <dir> <program> <out-name> -> echoes "file|bytes|sha" or nothing
# Packs the whole export folder: the program, its .pck and any native
# libraries (GDExtension .so/.dll). The program alone will not start.
zip_dir() {
  local dir="$1" program="$2" out="$3"
  [ -f "$dir/$program" ] || return 0
  rm -f "$DOWNLOADS/$out"
  ( cd "$dir" && zip -q -r -X "$DOWNLOADS/$out" . -x '*.import' )
  echo "$out|$(filesize "$DOWNLOADS/$out")|$(sha256 "$DOWNLOADS/$out")"
}

# copy_one <source> <out-name>
copy_one() {
  local src="$1" out="$2"
  [ -f "$src" ] || return 0
  cp -f "$src" "$DOWNLOADS/$out"
  echo "$out|$(filesize "$DOWNLOADS/$out")|$(sha256 "$DOWNLOADS/$out")"
}

echo "==> Reading $BUILD_DIR"

# Clear out old packages so the manifest never points at a stale file
find "$DOWNLOADS" -maxdepth 1 -type f ! -name .gitkeep -delete

WIN="$(zip_dir "$BUILD_DIR/windows" "LastExhibit.exe"    "LastExhibit-windows-x86_64.zip")"
LIN="$(zip_dir "$BUILD_DIR/linux"   "LastExhibit.x86_64" "LastExhibit-linux-x86_64.zip")"
MAC="$(copy_one "$BUILD_DIR/macos/LastExhibit.zip"        "LastExhibit-macos-universal.zip")"

WEB_AVAILABLE=false
if [ -f "$BUILD_DIR/web/index.html" ]; then
  find "$WEB" -mindepth 1 ! -name .gitkeep -delete
  cp -R "$BUILD_DIR/web/." "$WEB/"
  # Vercel serves /game/index.html under the address /game (cleanUrls), so
  # relative paths would resolve against the site root. A fixed base fixes it.
  if ! grep -q '<base href="/game/">' "$WEB/index.html"; then
    sed -i 's|<head>|<head>\n\t<base href="/game/">|' "$WEB/index.html"
  fi
  WEB_AVAILABLE=true
fi

# RELEASE_URL: wenn gesetzt, verlinkt die Website auf die Dateien im
# GitHub-Release statt auf downloads/ (z.B.
# RELEASE_URL=https://github.com/AlexanderGese/Last-Exhibit/releases/download/v1.0.0)
emit() {
  local key="$1" data="$2"
  if [ -n "$data" ]; then
    IFS='|' read -r file bytes sha <<<"$data"
    local url=""
    [ -n "${RELEASE_URL:-}" ] && url=", url: \"$RELEASE_URL/$file\""
    printf '    %s: { available: true, file: "%s", bytes: %s, sha256: "%s", added: "%s"%s }' \
      "$key" "$file" "$bytes" "$sha" "$TODAY" "$url"
  else
    printf '    %s: { available: false, file: null, bytes: 0, sha256: null, added: null }' "$key"
  fi
}

{
  echo "/* =========================================================================="
  echo "   Last Exhibit — build manifest"
  echo "   GENERATED FILE. Rewritten by scripts/sync-builds.sh; edits are overwritten."
  echo "   ========================================================================== */"
  echo
  echo "window.LE_BUILDS = {"
  echo "  generated: \"$TODAY\","
  if [ -n "$VERSION" ]; then echo "  version: \"$VERSION\","; else echo "  version: null,"; fi
  if [ "$WEB_AVAILABLE" = true ]; then
    echo "  web: { available: true, added: \"$TODAY\" },"
  else
    echo "  web: { available: false, added: null },"
  fi
  echo "  platforms: {"
  emit windows "$WIN"; echo ","
  emit macos   "$MAC"; echo ","
  emit linux   "$LIN"; echo
  echo "  }"
  echo "};"
} > "$MANIFEST"

echo
echo "Showcases:"
for pair in "windows:$WIN" "macos:$MAC" "linux:$LIN"; do
  key="${pair%%:*}"; data="${pair#*:}"
  if [ -n "$data" ]; then printf '  %-8s %s\n' "$key" "${data%%|*}"; else printf '  %-8s — empty\n' "$key"; fi
done
[ "$WEB_AVAILABLE" = true ] && echo "  browser  game/index.html" || echo "  browser  — empty"
echo
echo "Manifest written to assets/js/builds.js${VERSION:+ (version $VERSION)}"
