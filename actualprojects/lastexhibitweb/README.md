# Last Exhibit — website

The download and play-in-browser site. Static HTML, CSS and vanilla JS: no
build step, no dependencies. `index.html` opens straight from disk.

## Publishing a new build

```bash
cd ../../lastExhibit
./build.sh                      # or: ./build.sh web windows

cd ../actualprojects/lastexhibitweb
./scripts/sync-builds.sh
```

`sync-builds.sh` copies the exports out of `lastExhibit/build/` into
`downloads/` and `game/`, then rewrites `assets/js/builds.js` with the real
filenames, byte sizes and date. The page reads that manifest at load: a
platform with a build lights its display case, a platform without one leaves
the case empty and its button disabled. Nothing else needs editing.

Binaries are gitignored — the site ships the pages, the release ships the files.

## Local preview

```bash
./serve.py                      # http://localhost:8070
```

The browser build needs `Cross-Origin-Opener-Policy` and
`Cross-Origin-Embedder-Policy` headers, which `serve.py` sets. Opening
`index.html` by double-clicking works for everything except the embedded game.

## Deploying

`vercel.json` sets the same headers on Vercel; `_headers` does it on Netlify
and Cloudflare Pages. Any host works as long as those two headers are present
on `/game/*`, otherwise the WebAssembly build refuses to start.

## Editing text

All copy lives in `assets/js/i18n.js` as two dictionaries, English and German.
Markup carries `data-i18n="key"` and the script swaps text on toggle, storing
the choice in `localStorage`. Attributes are translated too, via
`data-i18n-alt`, `data-i18n-title`, `data-i18n-aria-label` and
`data-i18n-content`.

English is the source of truth. A key missing from the German dictionary falls
back to English rather than rendering blank.

## Layout

```
index.html            hero · premise · the note · eras · downloads · record · community
play.html             the browser build, or a notice when there isn't one
assets/css/site.css   all styles
assets/js/i18n.js     EN/DE dictionaries and the language toggle
assets/js/builds.js   generated manifest — do not edit by hand
assets/js/main.js     download cases, platform detection, scroll reveals
assets/js/play.js     iframe wiring for the browser build
assets/img/           art copied from the game (key art, artifacts)
assets/fonts/         Pixuf.ttf, the game's UI typeface
scripts/sync-builds.sh
serve.py              local server with the isolation headers
```

## Notes

Art and `Pixuf.ttf` are copied from `lastExhibit/assets/`. If the game's key
art changes, re-copy it — nothing links across directories at runtime.

The reference images in `Epochen/` are third-party mood boards and are
deliberately not used here.
