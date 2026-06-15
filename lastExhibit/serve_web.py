#!/usr/bin/env python3
"""Serve the Godot Web export on http://localhost:8060.

- Correct MIME for .wasm / .pck / .js so the browser streams properly
- COOP/COEP headers so cross-origin-isolation works if threads are enabled later
- No caching, so reloads always see the freshest build
"""
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import os, sys

PORT = int(os.environ.get("PORT", "8060"))
DIRECTORY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "build", "web")

class Handler(SimpleHTTPRequestHandler):
    extensions_map = {
        **SimpleHTTPRequestHandler.extensions_map,
        ".wasm": "application/wasm",
        ".pck":  "application/octet-stream",
        ".js":   "application/javascript",
        ".mjs":  "application/javascript",
        ".html": "text/html",
        ".png":  "image/png",
        ".svg":  "image/svg+xml",
    }

    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy",   "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Resource-Policy", "same-origin")
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def __init__(self, *a, **kw):
        super().__init__(*a, directory=DIRECTORY, **kw)

if not os.path.isdir(DIRECTORY):
    sys.exit(f"Web build not found at {DIRECTORY!r} — run ./build.sh web first.")

with ThreadingHTTPServer(("", PORT), Handler) as httpd:
    print(f"Serving {DIRECTORY}")
    print(f"  → http://localhost:{PORT}/index.html")
    print("Ctrl-C to stop.")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
