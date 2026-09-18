/* ==========================================================================
   Last Exhibit — sound

   Off until the visitor turns it on. Then two kinds of music:
     ambient  the main menu theme, while sound is on
     chosen   a track the visitor started by hand; it wins until it ends
              or they stop it
   Tracks crossfade over two <audio> elements. Short effects (David's jump
   and landing, the Flappy flap) are synthesised with Web Audio, so there
   are no extra files to load.

   Events on document:
     "soundchange"  { enabled }
     "trackchange"  { id, playing, chosen }
     "tracktime"    { id, current, duration }
   ========================================================================== */

(function () {
  "use strict";

  var data = window.LE_DATA || { tracks: [] };
  var byId = {};
  data.tracks.forEach(function (t) { byId[t.id] = t; });

  var VOLUME = 0.55;
  var FADE_MS = 1400;

  var decks = [new Audio(), new Audio()];
  decks.forEach(function (a) {
    a.preload = "none";
    a.loop = true;
    a.volume = 0;
  });
  var live = 0; // index of the deck that is (or is becoming) audible

  var state = {
    enabled: false,
    ambient: null,   // plays while sound is on
    chosen: null,    // track picked by hand
    current: null    // track actually playing
  };

  function emit(name, detail) {
    document.dispatchEvent(new CustomEvent(name, { detail: detail }));
  }

  /* ---------------- fades ---------------- */

  function fadeTo(audio, target, ms, done) {
    var from = audio.volume;
    var start = performance.now();
    var token = {};
    audio._fadeToken = token;
    function step(now) {
      if (audio._fadeToken !== token) return;
      var p = Math.min(1, (now - start) / ms);
      var eased = p < 0.5 ? 2 * p * p : 1 - Math.pow(-2 * p + 2, 2) / 2;
      audio.volume = Math.max(0, Math.min(1, from + (target - from) * eased));
      if (p < 1) requestAnimationFrame(step);
      else if (done) done();
    }
    requestAnimationFrame(step);
  }

  /* ---------------- core ---------------- */

  function switchTo(id, opts) {
    opts = opts || {};
    if (id === state.current && !opts.restart) {
      var d = decks[live];
      if (id && d.paused) d.play().catch(blocked);
      return;
    }

    var outgoing = decks[live];
    if (state.current) {
      fadeTo(outgoing, 0, opts.fast ? 300 : FADE_MS, function () { outgoing.pause(); });
    }

    state.current = id || null;
    if (!id || !byId[id]) {
      emit("trackchange", { id: null, playing: false, chosen: false });
      return;
    }

    live = 1 - live;
    var incoming = decks[live];
    var track = byId[id];
    if (incoming.dataset.src !== track.src) {
      incoming.src = track.src;
      incoming.dataset.src = track.src;
    }
    incoming.loop = !opts.once;
    if (opts.restart || opts.once) {
      try { incoming.currentTime = opts.at || 0; } catch (e) { /* not loaded yet */ }
    }
    incoming.volume = 0;
    var p = incoming.play();
    if (p && p.catch) p.catch(blocked);
    fadeTo(incoming, VOLUME, opts.fast ? 300 : FADE_MS);
    emit("trackchange", { id: id, playing: true, chosen: !!state.chosen });
  }

  function blocked(err) {
    if (err && err.name === "NotAllowedError") {
      setEnabled(false);
    }
  }

  function resolve() {
    if (!state.enabled) {
      switchTo(null, { fast: true });
      return;
    }
    switchTo(state.chosen || state.ambient);
  }

  function setEnabled(on) {
    state.enabled = !!on;
    if (!on) state.chosen = null;
    if (on) unlockContext();
    resolve();
    emit("soundchange", { enabled: state.enabled });
  }

  /* When a chosen track ends (soundtrack list plays once), fall back */
  decks.forEach(function (a) {
    a.addEventListener("ended", function () {
      if (state.chosen) {
        state.chosen = null;
        resolve();
      }
    });
    var last = 0;
    a.addEventListener("timeupdate", function () {
      if (a !== decks[live]) return;
      var now = performance.now();
      if (now - last < 250) return;
      last = now;
      emit("tracktime", { id: state.current, current: a.currentTime, duration: a.duration || (byId[state.current] || {}).dur || 0 });
    });
  });

  /* ---------------- synthesised effects ---------------- */

  var ctx = null;
  function unlockContext() {
    if (ctx) {
      if (ctx.state === "suspended") ctx.resume();
      return;
    }
    var AC = window.AudioContext || window.webkitAudioContext;
    if (!AC) return;
    try { ctx = new AC(); } catch (e) { ctx = null; }
  }

  var sfx = {
    /* David's jump: a rising square blip, like the game's */
    jump: function () {
      if (!state.enabled || !ctx) return;
      var t = ctx.currentTime;
      var o = ctx.createOscillator();
      var g = ctx.createGain();
      o.type = "square";
      o.frequency.setValueAtTime(220, t);
      o.frequency.exponentialRampToValueAtTime(660, t + 0.12);
      g.gain.setValueAtTime(0.06, t);
      g.gain.exponentialRampToValueAtTime(0.0001, t + 0.16);
      o.connect(g).connect(ctx.destination);
      o.start(t);
      o.stop(t + 0.17);
    },

    /* Landing on a plinth: a dull wooden thump */
    land: function () {
      if (!state.enabled || !ctx) return;
      var t = ctx.currentTime;
      var o = ctx.createOscillator();
      var g = ctx.createGain();
      o.type = "triangle";
      o.frequency.setValueAtTime(150, t);
      o.frequency.exponentialRampToValueAtTime(55, t + 0.12);
      g.gain.setValueAtTime(0.35, t);
      g.gain.exponentialRampToValueAtTime(0.0001, t + 0.16);
      o.connect(g).connect(ctx.destination);
      o.start(t);
      o.stop(t + 0.17);
    },

    /* A short flap for the phone game */
    flap: function () {
      if (!state.enabled || !ctx) return;
      var t = ctx.currentTime;
      var o = ctx.createOscillator();
      var g = ctx.createGain();
      o.type = "square";
      o.frequency.setValueAtTime(420, t);
      o.frequency.exponentialRampToValueAtTime(760, t + 0.07);
      g.gain.setValueAtTime(0.05, t);
      g.gain.exponentialRampToValueAtTime(0.0001, t + 0.09);
      o.connect(g).connect(ctx.destination);
      o.start(t);
      o.stop(t + 0.1);
    }
  };

  /* ---------------- public ---------------- */

  window.LE_AUDIO = {
    get enabled() { return state.enabled; },
    get current() { return state.current; },
    get chosen() { return state.chosen; },
    track: function (id) { return byId[id]; },

    toggle: function () { setEnabled(!state.enabled); },
    enable: function () { if (!state.enabled) setEnabled(true); },
    disable: function () { setEnabled(false); },

    /* The track that plays while sound is on and nothing was picked */
    setAmbient: function (id) {
      if (state.ambient === id) return;
      state.ambient = id || null;
      if (!state.chosen) resolve();
    },

    /* A track started by hand. Turns sound on — clicking play is consent. */
    choose: function (id, opts) {
      opts = opts || {};
      state.chosen = id;
      if (!state.enabled) {
        state.enabled = true;
        unlockContext();
        emit("soundchange", { enabled: true });
      }
      switchTo(id, { restart: opts.restart, once: opts.once });
    },

    /* Stop the hand-picked track and go back to the floor's music */
    release: function () {
      state.chosen = null;
      resolve();
    },

    seek: function (fraction) {
      var a = decks[live];
      if (a.duration) a.currentTime = a.duration * fraction;
    },

    sfx: sfx
  };
})();
