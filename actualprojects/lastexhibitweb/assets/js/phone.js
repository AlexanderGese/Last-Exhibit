/* ==========================================================================
   Last Exhibit — David's phone and the darknet listings

   The apps mirror scenes/Phone/*.gd: Classifieds (shop), Messages, Revospar,
   Settings, Tor (darknet), Museum, Flappy. Flappy is playable, with the
   game's own constants: gravity 1200, jump −400, pipes at 200 px/s, gap 190.
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

  var view, content, title, openApp = null, flappy = null;

  /* ---------------------------------------------------------------------
     App screens
     --------------------------------------------------------------------- */

  var APPS = {
    shop: {
      title: function () { return "Großanzeigen"; },
      render: function () {
        // Labels exactly as the game prints them, prices as the code charges
        var rows = [
          ["WW2 Unlock", "15 TS"],
          ["Middleage Unlock", "40 TS"],
          ["Japan Unlock", "25 TS"],
          ["Extend Leveltime", "250 $"],
          ["Museum app", "100 $"],
          ["Darknet app", "500 $"],
          ["Flappybird app", "250 $"]
        ];
        return "<p>" + t("phone.shopHint") + "</p>" + rows.map(function (r) {
          return '<p class="bubble" style="display:flex;justify-content:space-between;gap:.5rem;max-width:none"><span>' + r[0] + "</span><b style=\"color:#8fe07f;font-weight:400\">" + r[1] + "</b></p>";
        }).join("");
      }
    },

    messages: {
      title: function () { return t("phone.messages"); },
      render: function () {
        return '<p class="bubble">' + t("phone.msg1") + '</p><p class="bubble">' + t("phone.msg1") + '</p><p style="opacity:.6;margin-top:1rem">' + t("phone.msgNote") + "</p>";
      }
    },

    bank: {
      title: function () { return "Revospar"; },
      render: function () {
        return "<p><b style=\"font-weight:400\">" + t("phone.account") + "</b></p>" +
          row(t("phone.coins"), "1 240") + row(t("phone.shards"), "37") + row(t("phone.btc"), "58") +
          '<p style="margin-top:1rem"><b style="font-weight:400">' + t("phone.transactions") + "</b></p>" +
          row("Samurai-Mask", "+35 BTC") + row("Temporal Anchor", "−150 BTC") + row("Japan Unlock", "−25 TS") + row("Extend Leveltime", "−250 $");
      }
    },

    settings: {
      title: function () { return t("phone.settings"); },
      render: function () {
        return "<p>" + t("phone.settingsBody") + "</p>" +
          row("Master", "▮▮▮▮▮▮▯▯") + row("Music", "▮▮▮▮▮▯▯▯") + row("SFX", "▮▮▮▮▮▮▮▯") +
          '<p style="margin-top:1rem;opacity:.6">Keybinds · GameData · Reset Game Data</p>';
      }
    },

    tor: {
      title: function () { return "Tor"; },
      render: function () {
        var top = DATA.darknet.slice(0, 4);
        return "<p>" + t("phone.torIntro") + ' <b style="font-weight:400;color:#f2a93b">58 BTC</b></p>' +
          "<p>" + t("phone.torSell") + '</p><p style="opacity:.6">' + t("phone.torSellEmpty") + "</p>" +
          "<p>" + t("phone.torBuy") + "</p>" +
          top.map(function (d) { return row(d.name, d.btc + " BTC"); }).join("") +
          '<p style="margin-top:.8rem;opacity:.6">' + t("phone.torSee") + "</p>";
      }
    },

    museum: {
      title: function () { return "Museum"; },
      render: function () {
        // A worked example with the game's formulas:
        // visitors = 10 + reputation × level, ticket = 5 + displayed value / 100
        var rep = 14, level = 3, displayed = 2240;
        var visitors = 10 + rep * level;
        var ticket = 5 + Math.floor(displayed / 100);
        return row(t("phone.visitors"), String(visitors)) +
          row(t("phone.reputation"), String(rep)) +
          row(t("phone.ticket"), ticket + " €") +
          row(t("phone.income"), visitors * ticket + " €") +
          '<p style="margin-top:1rem;opacity:.6">' + t("phone.museumNote") + "</p>";
      }
    },

    flappy: {
      title: function () { return "Flappybird"; },
      render: function () {
        return '<canvas class="flappy" id="flappy" width="240" height="400" aria-label="Flappy Bird"></canvas>';
      },
      after: function () { flappy = Flappy($("#flappy")); },
      close: function () { if (flappy) { flappy.stop(); flappy = null; } }
    }
  };

  function row(a, b) {
    return '<p style="display:flex;justify-content:space-between;gap:.6rem;margin:0 0 .35rem"><span>' + a + '</span><span style="color:#f2e6c8">' + b + "</span></p>";
  }

  function open(name) {
    var app = APPS[name];
    if (!app) return;
    if (openApp && APPS[openApp].close) APPS[openApp].close();
    openApp = name;
    title.textContent = app.title();
    content.style.padding = name === "flappy" ? "0" : "";
    content.innerHTML = app.render();
    if (app.after) app.after();
    view.classList.add("is-open");
    $("#phone-back").focus({ preventScroll: true });
  }

  function close() {
    if (!openApp) return;
    var name = openApp;
    if (APPS[name].close) APPS[name].close();
    openApp = null;
    view.classList.remove("is-open");
    var btn = $('.app[data-app="' + name + '"]');
    if (btn) btn.focus({ preventScroll: true });
  }

  /* ---------------------------------------------------------------------
     Flappy — a small canvas port of scenes/Phone/flappybird.gd
     --------------------------------------------------------------------- */

  function Flappy(canvas) {
    var ctx = canvas.getContext("2d");
    // Match the phone screen's shape so nothing is stretched
    var W = 240;
    var H = Math.round(W * (canvas.clientHeight || 400) / (canvas.clientWidth || 240));
    canvas.width = W;
    canvas.height = H;
    // The game's phone screen is taller; scale its constants to this canvas
    var K = H / 520;
    var GRAVITY = 1200 * K, JUMP = -400 * K, SPEED = 200 * K, GAP = 190 * K, PIPE_W = 35 * K * 1.2;

    var bird = new Image();
    bird.src = "assets/img/phone/cubebird.png";
    var coin = new Image();
    coin.src = "assets/img/phone/coin.png";

    var best = 0;
    try { best = parseInt(localStorage.getItem("lastexhibit.flappy") || "0", 10) || 0; } catch (e) { /* ignore */ }

    var s = reset();
    var raf = 0, last = 0, alive = true;

    function reset() {
      return { y: H * 0.45, vy: 0, pipes: [], score: 0, playing: false, dead: false, spawn: 0 };
    }

    function flap() {
      if (s.dead) { s = reset(); return; }
      if (!s.playing) { s.playing = true; s.spawn = 0; }
      s.vy = JUMP;
      AUDIO.sfx.flap();
    }

    function step(dt) {
      if (!s.playing || s.dead) return;
      s.vy += GRAVITY * dt;
      s.y += s.vy * dt;
      s.spawn -= dt;
      if (s.spawn <= 0) {
        s.pipes.push({ x: W + 10, gap: 60 * K + Math.random() * (H - 120 * K - GAP) + GAP / 2, scored: false });
        s.spawn = 1.5;
      }
      var bx = W * 0.28, bw = 18, bh = 16;
      s.pipes.forEach(function (p) {
        p.x -= SPEED * dt;
        var top = p.gap - GAP / 2, bottom = p.gap + GAP / 2;
        var hitX = bx + bw > p.x && bx < p.x + PIPE_W;
        if (hitX && (s.y < top || s.y + bh > bottom)) die();
        if (!p.scored && p.x + PIPE_W < bx) { p.scored = true; s.score++; }
      });
      s.pipes = s.pipes.filter(function (p) { return p.x > -PIPE_W - 5; });
      if (s.y > H - bh || s.y < -40) die();
    }

    function die() {
      if (s.dead) return;
      s.dead = true;
      if (s.score > best) {
        best = s.score;
        try { localStorage.setItem("lastexhibit.flappy", String(best)); } catch (e) { /* ignore */ }
      }
    }

    function draw() {
      var g = ctx.createLinearGradient(0, 0, 0, H);
      g.addColorStop(0, "#4fb6e8");
      g.addColorStop(1, "#bfe8f7");
      ctx.fillStyle = g;
      ctx.fillRect(0, 0, W, H);

      ctx.fillStyle = "rgb(51,178,51)";
      s.pipes.forEach(function (p) {
        ctx.fillRect(Math.round(p.x), 0, PIPE_W, Math.round(p.gap - GAP / 2));
        ctx.fillRect(Math.round(p.x), Math.round(p.gap + GAP / 2), PIPE_W, H);
      });

      ctx.imageSmoothingEnabled = false;
      var tilt = Math.max(-0.5, Math.min(0.9, s.vy / 500));
      ctx.save();
      ctx.translate(W * 0.28 + 9, s.y + 8);
      ctx.rotate(tilt);
      if (bird.complete) ctx.drawImage(bird, -9, -8, 18, 16);
      else { ctx.fillStyle = "#ffd400"; ctx.fillRect(-9, -8, 18, 16); }
      ctx.restore();

      ctx.fillStyle = "#fff";
      ctx.strokeStyle = "#1a1a1a";
      ctx.lineWidth = 3;
      ctx.textAlign = "center";
      ctx.font = "28px Pixuf, monospace";
      ctx.strokeText(String(s.score), W / 2, 44);
      ctx.fillText(String(s.score), W / 2, 44);

      ctx.font = "10px Pixuf, monospace";
      if (!s.playing) {
        ctx.fillStyle = "#123";
        ctx.fillText(t("phone.flappyStart"), W / 2, H * 0.62);
        ctx.fillText(t("phone.flappyBest") + best, W / 2, H * 0.62 + 16);
        wrap(t("phone.flappyHint"), W / 2, H * 0.78, W - 30, 14);
      }
      if (s.dead) {
        ctx.fillStyle = "rgba(0,0,0,.55)";
        ctx.fillRect(0, H * 0.36, W, 92);
        ctx.fillStyle = "#fff";
        ctx.font = "16px Pixuf, monospace";
        ctx.fillText(t("phone.flappyOver") + s.score, W / 2, H * 0.36 + 34);
        ctx.font = "10px Pixuf, monospace";
        ctx.fillText("+" + Math.floor(s.score / 10), W / 2 + 8, H * 0.36 + 62);
        if (coin.complete) ctx.drawImage(coin, W / 2 - 26, H * 0.36 + 50, 16, 16);
        ctx.fillText(t("phone.flappyBest") + best, W / 2, H * 0.36 + 82);
      }
    }

    function wrap(text, x, y, max, lh) {
      var words = text.split(" "), line = "";
      words.forEach(function (w) {
        var test = line ? line + " " + w : w;
        if (ctx.measureText(test).width > max && line) {
          ctx.fillText(line, x, y);
          y += lh;
          line = w;
        } else line = test;
      });
      ctx.fillText(line, x, y);
    }

    function loop(now) {
      if (!alive) return;
      var dt = Math.min(0.033, (now - (last || now)) / 1000);
      last = now;
      step(dt);
      draw();
      raf = requestAnimationFrame(loop);
    }

    function onKey(e) {
      if (e.code === "Space" || e.key === "ArrowUp") {
        e.preventDefault();
        flap();
      }
    }

    canvas.tabIndex = 0;
    canvas.addEventListener("pointerdown", function (e) { e.preventDefault(); flap(); });
    canvas.addEventListener("keydown", onKey);
    canvas.focus({ preventScroll: true });
    raf = requestAnimationFrame(loop);

    return {
      stop: function () { alive = false; cancelAnimationFrame(raf); }
    };
  }

  /* ---------------------------------------------------------------------
     Listings under the phone
     --------------------------------------------------------------------- */

  function ledger() {
    var list = $("#ledger");
    if (!list) return;
    function paint() {
      list.innerHTML = DATA.darknet.map(function (d) {
        return '<li class="good"><img src="' + d.src + '" alt="" width="48" height="48" loading="lazy">' +
          '<span><span class="good__name">' + d.name + '</span><span class="good__desc">' + pick(d.effect) + "</span></span>" +
          '<span class="good__price">' + d.btc + " BTC</span></li>";
      }).join("");
    }
    paint();
    document.addEventListener("langchange", paint);
  }


  /* ---------------------------------------------------------------------
     Boot
     --------------------------------------------------------------------- */

  function boot() {
    view = $("#phone-view");
    content = $("#phone-content");
    title = $("#phone-title");
    if (!view) return;

    $("#phone-apps").addEventListener("click", function (e) {
      var app = e.target.closest(".app");
      if (app) open(app.dataset.app);
    });
    $("#phone-back").addEventListener("click", close);
    $("#phone").addEventListener("keydown", function (e) {
      if (e.key === "Escape") close();
    });
    document.addEventListener("langchange", function () {
      if (openApp && openApp !== "flappy") open(openApp);
    });


    ledger();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
