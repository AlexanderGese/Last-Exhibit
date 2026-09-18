#!/usr/bin/env python3
"""Serve the Last Exhibit site on http://localhost:8070.

The browser build needs cross-origin isolation, so this sets COOP/COEP the
same way lastExhibit/serve_web.py does. Opening index.html straight from disk
works for everything except the embedded game — use this to test that.

    ./serve.py            # port 8070
    PORT=9000 ./serve.py
"""
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import os
import sys

PORT = int(os.environ.get("PORT", "8070"))
DIRECTORY = os.path.dirname(os.path.abspath(__file__))


class Handler(SimpleHTTPRequestHandler):
    extensions_map = {
        **SimpleHTTPRequestHandler.extensions_map,
        ".wasm": "application/wasm",
        ".pck": "application/octet-stream",
        ".js": "application/javascript",
        ".mjs": "application/javascript",
        ".html": "text/html",
        ".css": "text/css",
        ".png": "image/png",
        ".svg": "image/svg+xml",
        ".ttf": "font/ttf",
    }

    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Resource-Policy", "same-origin")
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def log_message(self, fmt, *args):
        sys.stderr.write("  %s\n" % (fmt % args))


if __name__ == "__main__":
    with ThreadingHTTPServer(("0.0.0.0", PORT), Handler) as httpd:
        print(f"Last Exhibit — serving {DIRECTORY}")
        print(f"  http://localhost:{PORT}/")
        print(f"  http://localhost:{PORT}/play.html")
        print("Ctrl-C to stop.\n")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nClosed.")
