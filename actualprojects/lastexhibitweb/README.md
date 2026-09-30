# Last Exhibit — website

The download site. Static HTML, CSS and vanilla JS: no build step, no
dependencies. The only font is Pixuf, the game's own; music and art are local too.

The first screen is the download. Four museum plinths stand on the floor, one
per platform. David, the player sprite from the game, walks to the one for
your computer. Click any plinth and he jumps on it; when he lands, the
download starts.

## Publishing a new build

```bash
cd ../../lastExhibit
./build.sh                          # needs Godot 4.6 export templates

cd ../actualprojects/lastexhibitweb
VERSION=1.0 ./scripts/sync-builds.sh
```

`sync-builds.sh` packages the exports into `downloads/` and `game/`, then
rewrites `assets/js/builds.js` with filenames, sizes, dates and SHA-256
checksums. Windows and Linux export the program and its `.pck` separately, so
both go into one zip — the program alone won't start. A platform without an
export shows an empty plinth.

Binaries are gitignored. Add `?demo` to the URL to see every plinth filled
before real builds exist (the links go nowhere).

## Local preview

```bash
./serve.py                          # http://localhost:8070
```

## Deploying

`vercel.json` (Vercel) and `_headers` (Netlify, Cloudflare Pages) set the
cross-origin isolation headers. Everything is self-hosted because those
headers block most third-party files.

## Where things live

```
index.html              downloads · what is this · levels · artifacts · phone · music · install help
play.html               the browser build, or a notice when there isn't one
assets/css/site.css     all styles; buttons and boxes use the game's UI sprites
assets/img/ui/          button, dialogue box and item tablet from the game
assets/js/data.js       game facts: artifacts, eras, bosses, darknet items, tracks
assets/js/i18n.js       German copy (English is in the HTML) and the language switch
assets/js/stage.js      the plinths and David
assets/js/audio.js      music and the synthesised jump/land sounds
assets/js/main.js       collection, soundtrack list, install tabs, copy buttons
assets/js/eras.js       the time machine map
assets/js/phone.js      the phone apps and playable Flapbird
assets/js/builds.js     generated manifest — don't edit
assets/audio/           the game's 15 music tracks, as 80 kbps MP3
assets/img/             sprites and art copied from lastExhibit/assets
```

Everything in `data.js` is read from the Godot project (artifact `.tres`
files, boss scripts, dialogue files, the time machine UI). If the game
changes, update it there.

## Editing text

English lives in `index.html`. German lives in `assets/js/i18n.js` under the
same `data-i18n` key. A key missing from the German dictionary stays English.
