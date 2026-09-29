/* ==========================================================================
   Last Exhibit — the download stage

   Four plinths, one per platform, filled from the build manifest.
   David (the player sprite from the game, 32×64 frames) walks in and stands
   next to the plinth for your computer. Point at another one and he walks
   over. Click one and he jumps on it — when he lands, the download starts.

   Sprite rows in assets/img/sprites/david.png:
     0 idle (front) · 1 punch · 2 jump · 3 walk · 4 climb · 5 shoot
   ========================================================================== */

(function () {
  "use strict";

  var I18N = window.LE_I18N;
  var AUDIO = window.LE_AUDIO;
  var t = function (k) { return I18N.t(k); };
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };
  var reduced = window.matchMedia("(prefers-reduced-motion: reduce)");

  /* ----------------------------------------------------------------------
     Builds
     ---------------------------------------------------------------------- */

  var manifest = window.LE_BUILDS || { web: {}, platforms: {} };

  // ?demo fills every plinth so the page can be checked before real builds
  // exist. The files it points at don't exist.
  if (/[?&]demo\b/.test(location.search)) {
    var fake = function (file, bytes) {
      return { available: true, file: file, bytes: bytes, sha256: "0".repeat(64), added: "2026-09-17" };
    };
    manifest = {
      generated: "2026-09-17",
      version: "demo",
      web: { available: true, added: "2026-09-17" },
      platforms: {
        windows: fake("LastExhibit-windows-x86_64.zip", 71304211),
        macos: fake("LastExhibit-macos-universal.zip", 118220544),
        linux: fake("LastExhibit-linux-x86_64.zip", 69112832)
      }
    };
    window.LE_BUILDS = manifest;
  }

  function detectPlatform() {
    var uaData = navigator.userAgentData;
    var hay = (((uaData && uaData.platform) || "") + " " + navigator.userAgent + " " + (navigator.platform || "")).toLowerCase();
    if (/android|iphone|ipad|ipod|mobile/.test(hay)) return "mobile";
    if (/mac/.test(hay)) return "macos";
    if (/win/.test(hay)) return "windows";
    if (/linux|x11|cros/.test(hay)) return "linux";
    return null;
  }
  var detected = detectPlatform();
  window.LE_PLATFORM = detected;

  var NAME = { windows: "Windows", macos: "macOS", linux: "Linux", web: "Browser" };

  function build(key) {
    if (key === "web") return manifest.web && manifest.web.available ? { href: "play.html", web: true } : null;
    var b = (manifest.platforms || {})[key];
    return b && b.available && b.file ? { href: "downloads/" + b.file, bytes: b.bytes, sha256: b.sha256, added: b.added } : null;
  }

  function size(bytes) {
    if (!bytes) return "";
    var mb = bytes / 1048576;
    return (mb >= 100 ? Math.round(mb) : mb.toFixed(1)) + " MB";
  }

  function paintPlinths() {
    $$(".plinth").forEach(function (p) {
      var key = p.dataset.platform;
      var b = build(key);
      var meta = $("[data-slot='meta']", p);
      p.classList.toggle("is-detected", key === home());
      if (b) {
        p.href = b.href;
        if (!b.web) p.setAttribute("download", "");
        p.removeAttribute("aria-disabled");
        p.removeAttribute("tabindex");
        p.removeAttribute("role");
        meta.textContent = b.web ? t("stage.metaPlay") : size(b.bytes);
      } else {
        p.removeAttribute("href");
        p.removeAttribute("download");
        p.setAttribute("aria-disabled", "true");
        p.setAttribute("role", "link");
        p.tabIndex = 0;
        meta.textContent = t("stage.metaSoon");
      }
      p.setAttribute("aria-label", (key === "web" ? t("stage.webName") : NAME[key]) + ": " + (b ? (b.web ? t("stage.metaPlay") : t("stage.download") + ", " + size(b.bytes)) : t("stage.metaSoon")));
    });

    // The line under the floor: version, size and checksum for your build
    var info = $("#info-build");
    var hash = $("#info-hash");
    var mine = detected && detected !== "mobile" ? build(detected) : null;
    info.removeAttribute("data-i18n");
    if (mine) {
      var parts = [];
      if (manifest.version) parts.push((/^\d/.test(manifest.version) ? "v" : "") + manifest.version);
      parts.push(NAME[detected] + " " + size(mine.bytes));
      if (mine.added) parts.push(formatDate(mine.added));
      info.textContent = parts.join(" · ");
      if (mine.sha256) {
        hash.hidden = false;
        hash.innerHTML = 'SHA-256 <code title="' + mine.sha256 + '">' + mine.sha256.slice(0, 12) + "…</code> " +
          '<button type="button" class="linkish" data-copy-text="' + mine.sha256 + '">' + t("ui.copy") + "</button>";
      }
    } else {
      hash.hidden = true;
      info.textContent = anyBuild() ? t("stage.pickOne") : t("stage.noBuild");
    }
  }

  function anyBuild() {
    return ["windows", "macos", "linux", "web"].some(function (k) { return !!build(k); });
  }

  function formatDate(iso) {
    var d = new Date(iso + "T00:00:00");
    if (isNaN(d)) return iso;
    return d.toLocaleDateString(I18N.lang === "de" ? "de-DE" : "en-GB", { day: "numeric", month: "short", year: "numeric" });
  }

  /* Which plinth David treats as yours */
  function home() {
    if (detected && detected !== "mobile") return detected;
    return "web";
  }

  /* ----------------------------------------------------------------------
     David
     ---------------------------------------------------------------------- */

  var floor, el, shadow, bubble, stage;
  var ds = 3;               // pixel scale, read from CSS
  var FW = 96, FH = 192;    // frame size on screen

  var ROW = { idle: 0, punch: 1, jump: 2, walk: 3 };

  var s = {
    x: -120, y: 0,
    face: 1,
    anim: "idle", frame: 0, clock: 0,
    on: null,               // plinth he's standing on
    queue: [],              // steps still to do
    step: null,             // step in progress
    busy: false             // true while carrying out a click
  };

  function readScale() {
    ds = parseFloat(getComputedStyle(stage).getPropertyValue("--ds")) || 3;
    FW = 32 * ds;
    FH = 64 * ds;
  }

  function centre(p) { return p.offsetLeft + p.offsetWidth / 2; }
  function top(p) { return p.offsetHeight; }

  /* Where to stand on the floor next to a plinth, on the side he's coming from */
  function besideX(p) {
    var c = centre(p);
    var side = s.x < c ? -1 : 1;
    return c + side * (p.offsetWidth / 2 + FW * 0.28);
  }

  function draw() {
    var col, row;
    switch (s.anim) {
      case "walk": row = ROW.walk; col = s.frame % 6; break;
      case "crouch": row = ROW.jump; col = 2; break;
      case "air": row = ROW.jump; col = 5; break;
      case "punch": row = ROW.punch; col = Math.min(4, s.frame); break;
      default: row = ROW.idle; col = s.frame % 5;
    }
    el.style.backgroundPosition = (-col * FW) + "px " + (-row * FH) + "px";
    el.style.transform = "translate3d(" + s.x.toFixed(1) + "px," + (-s.y).toFixed(1) + "px,0) scaleX(" + s.face + ")";

    // The shadow stays on whatever surface is under him
    var ground = 0;
    $$(".plinth", floor).forEach(function (p) {
      if (Math.abs(s.x - centre(p)) < p.offsetWidth / 2 && s.y >= top(p) - 2) ground = top(p);
    });
    var lift = Math.max(0, s.y - ground);
    var k = Math.max(0.35, 1 - lift / 160);
    shadow.style.transform = "translate3d(" + s.x.toFixed(1) + "px," + (-ground).toFixed(1) + "px,0) scale(" + k.toFixed(2) + ")";
    shadow.style.opacity = String(k);

    if (bubble.classList.contains("is-on")) placeBubble();
  }

  function placeBubble() {
    bubble.style.transform = "";
    bubble.style.left = s.x + "px";
    bubble.style.bottom = (s.y + FH + parseFloat(getComputedStyle(stage).getPropertyValue("--floor")) + 8) + "px";
    // Keep it on screen
    var r = bubble.getBoundingClientRect();
    var fr = floor.getBoundingClientRect();
    var shift = 0;
    if (r.left < fr.left + 8) shift = fr.left + 8 - r.left;
    if (r.right > fr.right - 8) shift = fr.right - 8 - r.right;
    if (shift) bubble.style.left = (s.x + shift) + "px";
  }

  var sayTimer = 0;
  function say(text, ms) {
    bubble.textContent = text;
    bubble.classList.add("is-on");
    placeBubble();
    clearTimeout(sayTimer);
    sayTimer = setTimeout(function () { bubble.classList.remove("is-on"); }, ms || 2000);
  }

  /* ---------------- steps ---------------- */

  function walkTo(x, fast) { return { type: "walk", x: x, fast: fast }; }
  function jumpTo(x, y, onto) { return { type: "jump", x: x, y: y, onto: onto }; }
  function doThen(fn) { return { type: "call", fn: fn }; }

  function run(steps) {
    s.queue = steps;
    s.step = null;
    next();
  }

  function next() {
    s.step = s.queue.shift() || null;
    if (!s.step) {
      s.anim = "idle";
      return;
    }
    var st = s.step;
    if (st.type === "walk") {
      if (Math.abs(st.x - s.x) < 2) return next();
      s.anim = "walk";
      s.face = st.x > s.x ? 1 : -1;
    } else if (st.type === "jump") {
      st.x0 = s.x; st.y0 = s.y; st.t = 0;
      var dist = Math.abs(st.x - s.x);
      st.dur = Math.min(0.62, 0.34 + dist / 900);
      st.arc = Math.max(40, Math.abs(st.y - s.y) * 0.6 + 34 * (ds / 3));
      if (Math.abs(st.x - s.x) > 1) s.face = st.x > s.x ? 1 : -1;
      s.anim = "crouch";
      s.on = null;
      AUDIO.sfx.jump && AUDIO.sfx.jump();
    } else if (st.type === "call") {
      s.step = null;
      st.fn();
      next();
    }
  }

  var last = 0;
  function tick(now) {
    var dt = Math.min(0.05, (now - (last || now)) / 1000);
    last = now;
    var st = s.step;

    if (st && st.type === "walk") {
      var speed = (st.fast ? 520 : 230) * (ds / 3);
      var d = st.x - s.x;
      var move = speed * dt;
      if (Math.abs(d) <= move) {
        s.x = st.x;
        next();
      } else {
        s.x += Math.sign(d) * move;
      }
      s.clock += dt;
      if (s.clock > (st && st.fast ? 0.06 : 0.09)) { s.clock = 0; s.frame++; }
    } else if (st && st.type === "jump") {
      st.t += dt;
      var p = Math.min(1, st.t / st.dur);
      s.x = st.x0 + (st.x - st.x0) * p;
      s.y = st.y0 + (st.y - st.y0) * p + st.arc * 4 * p * (1 - p);
      s.anim = p < 0.12 ? "crouch" : p > 0.9 ? "crouch" : "air";
      if (p >= 1) {
        s.y = st.y;
        s.on = st.onto || null;
        land(st.onto);
        next();
      }
    } else if (s.anim === "punch") {
      s.clock += dt;
      if (s.clock > 0.07) { s.clock = 0; s.frame++; }
      if (s.frame > 5) { s.anim = "idle"; s.frame = 0; }
    } else {
      // idle: slow breathing through the 5 front-facing frames
      s.clock += dt;
      if (s.clock > 0.22) { s.clock = 0; s.frame++; }
    }

    draw();
    raf = requestAnimationFrame(tick);
  }
  var raf = 0;

  function land(plinth) {
    // dust
    var n = 5;
    for (var i = 0; i < n; i++) {
      var puff = document.createElement("span");
      puff.className = "puff";
      puff.style.left = (s.x - 5 + (i - 2) * 6) + "px";
      puff.style.bottom = (s.y + parseFloat(getComputedStyle(stage).getPropertyValue("--floor"))) + "px";
      puff.style.setProperty("--px", ((i - 2) * 12) + "px");
      floor.appendChild(puff);
      setTimeout(puff.remove.bind(puff), 520);
    }
    if (plinth) {
      plinth.classList.add("is-pressed", "is-landed");
      setTimeout(function () { plinth.classList.remove("is-pressed"); }, 160);
      setTimeout(function () { plinth.classList.remove("is-landed"); }, 1400);
    }
    AUDIO.sfx.land && AUDIO.sfx.land();
  }

  /* ---------------- what the visitor does ---------------- */

  function wander(p) {
    if (s.busy || reduced.matches) return;
    var steps = [];
    if (s.on === p) return;
    if (s.on) {
      // hop down on the side facing the new plinth
      var from = s.on;
      var dir = centre(p) > centre(from) ? 1 : -1;
      steps.push(jumpTo(centre(from) + dir * (from.offsetWidth / 2 + FW * 0.3), 0, null));
    }
    steps.push(doThen(function () { s.queue.unshift(walkTo(besideX(p))); }));
    run(steps);
  }

  function climb(p) {
    s.busy = true;
    bubble.classList.remove("is-on");
    var steps = [];
    if (s.on === p) {
      steps.push(jumpTo(centre(p), top(p), p));  // a little hop in place
    } else {
      if (s.on) {
        var from = s.on;
        var dir = centre(p) > centre(from) ? 1 : -1;
        steps.push(jumpTo(centre(from) + dir * (from.offsetWidth / 2 + FW * 0.3), 0, null));
      }
      steps.push(doThen(function () {
        // decide which side to approach from once he's on the floor
        s.queue.unshift(walkTo(besideX(p), true), jumpTo(centre(p), top(p), p));
      }));
    }
    steps.push(doThen(function () { act(p); }));
    run(steps);
  }

  function act(p) {
    var key = p.dataset.platform;
    var b = build(key);
    s.busy = false;
    if (!b) {
      s.anim = "punch";
      s.frame = 0;
      say(t("stage.sayEmpty"), 2200);
      return;
    }
    say(b.web ? t("stage.sayPlay") : t("stage.sayDownload"), 2400);
    setTimeout(function () { start(b); }, 380);
  }

  function start(b) {
    if (b.web) {
      location.href = b.href;
      return;
    }
    var a = document.createElement("a");
    a.href = b.href;
    a.setAttribute("download", "");
    a.style.display = "none";
    document.body.appendChild(a);
    a.click();
    a.remove();
  }

  /* ----------------------------------------------------------------------
     Wiring
     ---------------------------------------------------------------------- */

  function wire() {
    $$(".plinth", floor).forEach(function (p) {
      p.addEventListener("pointerenter", function (e) {
        if (e.pointerType === "mouse") wander(p);
      });
      p.addEventListener("focus", function () { wander(p); });

      p.addEventListener("click", function (e) {
        e.preventDefault();
        if (reduced.matches) {
          // No walking: stand him on it and go
          s.x = centre(p); s.y = top(p); s.on = p;
          draw();
          act(p);
          return;
        }
        if (s.busy) {
          // Changed his mind: finish the current step, then head for this one
          s.queue = [doThen(function () { s.busy = false; climb(p); })];
          return;
        }
        climb(p);
      });

      // Disabled plinths aren't real links, so Enter needs handling
      p.addEventListener("keydown", function (e) {
        if ((e.key === "Enter" || e.key === " ") && !p.hasAttribute("href")) {
          e.preventDefault();
          p.click();
        }
      });
    });

    window.addEventListener("resize", function () {
      readScale();
      if (s.on) { s.x = centre(s.on); s.y = top(s.on); }
      draw();
    });

    document.addEventListener("langchange", function () {
      paintPlinths();
      bubble.classList.remove("is-on");
    });
  }

  function intro() {
    var mine = $('.plinth[data-platform="' + home() + '"]', floor);
    if (reduced.matches) {
      s.x = besideX(mine);
      s.face = 1;
      draw();
      return;
    }
    s.x = -FW;
    s.face = 1;
    draw();
    setTimeout(function () {
      run([
        walkTo(besideX(mine)),
        doThen(function () {
          s.face = 1;
          if (!s.busy) say(anyBuild() ? t("stage.sayHint") : t("stage.sayWaiting"), 2600);
        })
      ]);
    }, 500);
    raf = requestAnimationFrame(tick);
  }

  function boot() {
    stage = $(".stage");
    floor = $("#platforms");
    el = $("#david");
    shadow = $("#david-shadow");
    bubble = $("#say");
    if (!stage || !floor) return;

    paintPlinths();
    readScale();
    wire();
    // Wait for the sprite sheet so he doesn't walk in as an empty box
    var img = new Image();
    img.onload = img.onerror = intro;
    img.src = "assets/img/sprites/david.png";
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
