/* ==========================================================================
   Last Exhibit — the time machine console

   The in-game epoch screen: a parchment world map with pins and a year bar.
   Picking a pin re-tints the section, swaps the boss sprite, the weather,
   the quote, the loot, and — with sound on — the music.
   ========================================================================== */

(function () {
  "use strict";

  var DATA = window.LE_DATA;
  var AUDIO = window.LE_AUDIO;
  var I18N = window.LE_I18N;
  var t = function (k) { return I18N.t(k); };
  var pick = function (p) { return I18N.pick(p); };
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };
  var reduced = window.matchMedia("(prefers-reduced-motion: reduce)");

  var section, map, keys, readout;
  var current = DATA.eras[0];
  var tape = "level"; // which of the era's two tracks the tape buttons follow
  var quoteIndex = 0;


  /* ---------------------------------------------------------------------
     Build pins and chips
     --------------------------------------------------------------------- */

  function build() {
    DATA.eras.forEach(function (era) {
      var pin = document.createElement("button");
      pin.className = "pin";
      pin.type = "button";
      pin.dataset.era = era.id;
      pin.style.setProperty("--x", era.pin.x + "%");
      pin.style.setProperty("--y", era.pin.y + "%");
      if (era.locked) pin.dataset.locked = "true";
      pin.innerHTML = '<span class="pin__label"></span>';
      pin.addEventListener("click", function () { select(era, true); });
      map.appendChild(pin);

      var chip = document.createElement("button");
      chip.className = "chip";
      chip.type = "button";
      chip.dataset.era = era.id;
      if (era.locked) chip.dataset.locked = "true";
      chip.addEventListener("click", function () { select(era, true); });
      keys.appendChild(chip);
    });

    // Arrow keys move between eras when a chip or pin has focus
    [map, keys].forEach(function (group) {
      group.addEventListener("keydown", function (e) {
        var d = e.key === "ArrowRight" || e.key === "ArrowDown" ? 1 : e.key === "ArrowLeft" || e.key === "ArrowUp" ? -1 : 0;
        if (!d) return;
        e.preventDefault();
        var list = DATA.eras;
        var next = list[(list.indexOf(current) + d + list.length) % list.length];
        select(next, true);
        var sel = group.querySelector('[data-era="' + next.id + '"]');
        if (sel) sel.focus();
      });
    });

    $$("[data-tape]", section).forEach(function (b) {
      b.addEventListener("click", function () {
        var kind = b.dataset.tape;
        var id = current.tracks[kind];
        if (AUDIO.chosen === id) {
          AUDIO.release();
        } else {
          tape = kind;
          AUDIO.choose(id);
        }
      });
    });

    // Cycle the NPC's lines slowly while the era is shown
    setInterval(function () {
      if (!current || !current.quotes.length || document.hidden) return;
      if (!isVisible()) return;
      quoteIndex = (quoteIndex + 1) % current.quotes.length;
      paintQuote();
    }, 7000);

    document.addEventListener("trackchange", paintTapes);
  }

  /* ---------------------------------------------------------------------
     Select an era
     --------------------------------------------------------------------- */

  function select(era, byHand) {
    var changed = era !== current;
    current = era;
    quoteIndex = 0;
    section.dataset.era = era.id;

    $$(".pin", map).forEach(function (p) { p.setAttribute("aria-pressed", String(p.dataset.era === era.id)); });
    $$(".chip", keys).forEach(function (c) { c.setAttribute("aria-pressed", String(c.dataset.era === era.id)); });

    $("#tl-handle").style.setProperty("--t", era.t + "%");
    var years = $("#tl-years");
    years.style.setProperty("--t", era.t + "%");
    years.textContent = era.year;
    $("#era-status").textContent = era.year + " · " + pick(era.name);

    if (changed && byHand && !reduced.matches) {
      readout.classList.remove("is-tuning");
      void readout.offsetWidth;
      readout.classList.add("is-tuning");
    }

    paint();
    weather.set(era.id);

    // If a tape of the previous era was playing, follow along to this one
    if (changed && AUDIO.chosen) {
      var wasEra = DATA.eras.some(function (e) { return e.tracks.level === AUDIO.chosen || e.tracks.boss === AUDIO.chosen; });
      if (wasEra) AUDIO.choose(era.tracks[tape]);
    }
  }

  function paint() {
    var era = current;
    readout.classList.toggle("is-locked", !!era.locked);

    $("#ro-year").textContent = era.year;
    $("#ro-name").textContent = pick(era.name);
    $("#ro-mood").textContent = pick(era.mood);

    var facts = [
      [t("eras.place"), pick(era.place)],
      [t("eras.unlock"), pick(era.unlock)]
    ];
    if (!era.locked) {
      facts.push([t("eras.boss"), pick(era.boss)]);
      facts.push([t("eras.health"), era.hp + " HP"]);
      facts.push([t("eras.attacks"), pick(era.attacks)]);
      facts.push([t("eras.shards"), String(era.shards)]);
    }
    $("#ro-facts").innerHTML = facts.map(function (f) {
      return "<dt>" + f[0] + "</dt><dd>" + escapeHtml(f[1]) + "</dd>";
    }).join("");

    paintQuote();

    var loot = DATA.artifacts.filter(function (a) { return a.era === era.id; });
    $("#ro-loot").innerHTML = loot.length
      ? loot.map(function (a) {
          return '<img src="' + a.src + '" alt="' + escapeHtml(a.name) + '" title="' + escapeHtml(a.name) + " · " + a.value + '" width="40" height="40">';
        }).join("")
      : '<span class="muted">' + t("eras.nothing") + "</span>";

    // Pin labels and chips
    $$(".pin", map).forEach(function (p) {
      var e = byId(p.dataset.era);
      p.querySelector(".pin__label").textContent = e.year;
      p.setAttribute("aria-label", pick(e.name) + ", " + e.year + (e.locked ? " — " + t("eras.sealed") : ""));
    });
    $$(".chip", keys).forEach(function (c) {
      var e = byId(c.dataset.era);
      c.textContent = pick(e.name);
    });

    sprite.set(era);
    paintTapes();
  }

  function paintQuote() {
    var q = current.quotes[quoteIndex];
    var box = $("#ro-quote");
    if (!q) { box.hidden = true; return; }
    box.hidden = false;
    $("#ro-quote-text").textContent = "“" + pick(q).replace(/^“|”$/g, "") + "”";
    $("#ro-quote-who").textContent = "— " + current.npc;
  }

  function paintTapes() {
    $$("[data-tape]", section).forEach(function (b) {
      var id = current.tracks[b.dataset.tape];
      var on = AUDIO.enabled && AUDIO.chosen === id && AUDIO.current === id;
      b.setAttribute("aria-pressed", String(on));
      $("use", b).setAttribute("href", on ? "#i-pause" : "#i-play");
    });
  }

  function byId(id) {
    for (var i = 0; i < DATA.eras.length; i++) if (DATA.eras[i].id === id) return DATA.eras[i];
    return null;
  }
  function escapeHtml(s) {
    return String(s).replace(/[&<>"]/g, function (c) { return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]; });
  }
  function isVisible() {
    var r = section.getBoundingClientRect();
    return r.bottom > 0 && r.top < window.innerHeight;
  }

  /* ---------------------------------------------------------------------
     Boss sprite — frames stepped by hand so any sheet layout works
     --------------------------------------------------------------------- */

  var sprite = {
    el: null,
    spec: null,
    frame: 0,
    last: 0,
    raf: 0,

    set: function (era) {
      var el = this.el;
      cancelAnimationFrame(this.raf);
      this.spec = era.sprite;
      if (!era.sprite) {
        el.style.backgroundImage = "none";
        el.style.width = el.style.height = "0";
        el.setAttribute("aria-label", "");
        var seal = readout.querySelector(".lockseal");
        if (!seal) {
          seal = document.createElement("span");
          seal.className = "lockseal";
          seal.setAttribute("aria-hidden", "true");
          seal.textContent = "?";
          readout.querySelector(".readout__stage").appendChild(seal);
        }
        return;
      }
      var old = readout.querySelector(".lockseal");
      if (old) old.remove();

      var s = era.sprite;
      var stage = readout.querySelector(".readout__stage");
      // Fit the sprite to the stage height, never smoothing the pixels
      var room = stage.clientHeight * 0.95;
      var scale = Math.max(1, Math.floor(Math.min(s.scale * 2, room / s.fh) * 2) / 2);
      if (s.fw > 300) scale = Math.min(s.scale, (stage.clientWidth * 0.8) / s.fw);
      var rows = Math.ceil(s.frames / s.cols);
      el.style.width = s.fw * scale + "px";
      el.style.height = s.fh * scale + "px";
      el.style.backgroundImage = "url('" + s.src + "')";
      el.style.backgroundSize = s.cols * s.fw * scale + "px " + rows * s.fh * scale + "px";
      el.style.bottom = s.fw > 300 ? "34%" : "8%";
      el.dataset.scale = scale;
      el.setAttribute("aria-label", pick(era.boss));
      this.frame = 0;
      this.draw();
      if (!reduced.matches) this.loop();
    },

    draw: function () {
      var s = this.spec;
      if (!s) return;
      var scale = parseFloat(this.el.dataset.scale);
      var col = this.frame % s.cols;
      var row = Math.floor(this.frame / s.cols);
      this.el.style.backgroundPosition = -col * s.fw * scale + "px " + -row * s.fh * scale + "px";
    },

    loop: function () {
      var self = this;
      function tick(now) {
        if (!self.spec) return;
        if (now - self.last > 1000 / self.spec.fps) {
          self.last = now;
          self.frame = (self.frame + 1) % self.spec.frames;
          self.draw();
        }
        self.raf = requestAnimationFrame(tick);
      }
      this.raf = requestAnimationFrame(tick);
    }
  };

  /* ---------------------------------------------------------------------
     Weather — one canvas, a different sky for every era
     --------------------------------------------------------------------- */

  var weather = {
    canvas: null,
    ctx: null,
    kind: null,
    parts: [],
    w: 0,
    h: 0,
    running: false,
    flash: 0,
    raf: 0,

    init: function (canvas) {
      this.canvas = canvas;
      this.ctx = canvas.getContext("2d");
      var self = this;
      this.resize();
      window.addEventListener("resize", function () { self.resize(); });
      if (reduced.matches) return;
      new IntersectionObserver(function (entries) {
        var on = entries[0].isIntersecting;
        if (on && !self.running) { self.running = true; self.raf = requestAnimationFrame(function f(now) { self.frame(now); if (self.running) self.raf = requestAnimationFrame(f); }); }
        if (!on) { self.running = false; cancelAnimationFrame(self.raf); }
      }).observe(section);
    },

    resize: function () {
      var dpr = Math.min(window.devicePixelRatio || 1, 1.5);
      this.w = this.canvas.clientWidth;
      this.h = this.canvas.clientHeight;
      this.canvas.width = this.w * dpr;
      this.canvas.height = this.h * dpr;
      this.ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      if (this.kind) this.set(this.kind, true);
    },

    set: function (kind, force) {
      if (kind === this.kind && !force) return;
      this.kind = kind;
      var n = { soviet: 70, ww2: 40, medieval: 220, japan: 55, inca: 60 }[kind] || 0;
      n = Math.round(n * Math.min(1.4, (this.w * this.h) / (1400 * 900)));
      this.parts = [];
      for (var i = 0; i < n; i++) this.parts.push(this.spawn(true));
    },

    spawn: function (anywhere) {
      var w = this.w, h = this.h, r = Math.random;
      switch (this.kind) {
        case "soviet":   // embers rising from somewhere below
          return { x: r() * w, y: anywhere ? r() * h : h + 10, vx: (r() - 0.5) * 0.4, vy: -(0.3 + r() * 0.8), s: 1 + r() * 2, life: r() };
        case "ww2":      // high clouds of dust in searchlight beams
          return { x: r() * w, y: r() * h * 0.7, vx: 0.08 + r() * 0.15, vy: 0, s: 1 + r() * 1.5, life: r() };
        case "medieval": // rain
          return { x: r() * (w + 200) - 100, y: anywhere ? r() * h : -20, vx: -2.2, vy: 11 + r() * 6, s: 10 + r() * 14, life: 1 };
        case "japan":    // blossom petals
          return { x: anywhere ? r() * w : -20, y: r() * h, vx: 0.4 + r() * 0.7, vy: 0.15 + r() * 0.45, s: 2 + r() * 3, rot: r() * 6, vr: (r() - 0.5) * 0.05, life: r() };
        case "inca":     // gold dust
          return { x: r() * w, y: anywhere ? r() * h : h + 10, vx: (r() - 0.5) * 0.15, vy: -(0.1 + r() * 0.3), s: 1 + r() * 1.5, life: r() };
      }
      return {};
    },

    frame: function (now) {
      var c = this.ctx, w = this.w, h = this.h, k = this.kind;
      c.clearRect(0, 0, w, h);

      if (k === "soviet") {
        // the emergency light sweeps round
        var a = (Math.sin(now / 900) + 1) / 2;
        c.fillStyle = "rgba(210,30,20," + (0.03 + a * 0.07).toFixed(3) + ")";
        c.fillRect(0, 0, w, h);
      }
      if (k === "ww2") {
        [0, 1].forEach(function (i) {
          var ang = Math.sin(now / (2600 + i * 900) + i * 2) * 0.55 - Math.PI / 2;
          var ox = w * (0.25 + i * 0.5), oy = h + 20;
          var len = h * 1.4, spread = 0.07;
          var g = c.createLinearGradient(ox, oy, ox + Math.cos(ang) * len, oy + Math.sin(ang) * len);
          g.addColorStop(0, "rgba(255,248,210,0.16)");
          g.addColorStop(1, "rgba(255,248,210,0)");
          c.fillStyle = g;
          c.beginPath();
          c.moveTo(ox, oy);
          c.lineTo(ox + Math.cos(ang - spread) * len, oy + Math.sin(ang - spread) * len);
          c.lineTo(ox + Math.cos(ang + spread) * len, oy + Math.sin(ang + spread) * len);
          c.closePath();
          c.fill();
        });
      }
      if (k === "medieval") {
        if (this.flash <= 0 && Math.random() < 0.003) this.flash = 1;
        if (this.flash > 0) {
          var f = this.flash > 0.8 || (this.flash > 0.45 && this.flash < 0.6) ? this.flash : this.flash * 0.3;
          c.fillStyle = "rgba(225,235,255," + (f * 0.22).toFixed(3) + ")";
          c.fillRect(0, 0, w, h);
          this.flash -= 0.03;
        }
      }

      for (var i = 0; i < this.parts.length; i++) {
        var p = this.parts[i];
        p.x += p.vx;
        p.y += p.vy;
        if (k === "japan") { p.rot += p.vr; p.x += Math.sin(now / 900 + i) * 0.2; }
        var out = p.y > h + 30 || p.y < -30 || p.x > w + 110 || p.x < -110;
        if (out) { this.parts[i] = this.spawn(false); continue; }

        if (k === "soviet") {
          c.fillStyle = "rgba(255," + (120 + ((i * 37) % 80)) + ",60," + (0.35 + 0.4 * Math.abs(Math.sin(now / 300 + i))).toFixed(2) + ")";
          c.fillRect(p.x, p.y, p.s, p.s);
        } else if (k === "ww2") {
          c.fillStyle = "rgba(230,230,210,0.18)";
          c.fillRect(p.x, p.y, p.s, p.s);
          if (p.x > w + 5) p.x = -5;
        } else if (k === "medieval") {
          c.strokeStyle = "rgba(180,195,220,0.28)";
          c.lineWidth = 1;
          c.beginPath();
          c.moveTo(p.x, p.y);
          c.lineTo(p.x + p.vx * 1.6, p.y + p.s);
          c.stroke();
        } else if (k === "japan") {
          c.save();
          c.translate(p.x, p.y);
          c.rotate(p.rot);
          c.fillStyle = "rgba(246,190,205,0.6)";
          c.fillRect(-p.s, -p.s / 2, p.s * 2, p.s);
          c.restore();
        } else if (k === "inca") {
          c.fillStyle = "rgba(240,200,90," + (0.25 + 0.35 * Math.abs(Math.sin(now / 700 + i))).toFixed(2) + ")";
          c.fillRect(p.x, p.y, p.s, p.s);
        }
      }
    }
  };

  /* ---------------------------------------------------------------------
     Boot
     --------------------------------------------------------------------- */

  function boot() {
    section = $("#eras");
    map = $("#chart-map");
    keys = $("#era-keys");
    readout = $("#readout");
    if (!section || !map) return;
    sprite.el = $("#ro-sprite");

    build();
    weather.init($("#weather"));
    select(current, false);

    document.addEventListener("langchange", paint);
    window.addEventListener("resize", function () { sprite.set(current); });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
