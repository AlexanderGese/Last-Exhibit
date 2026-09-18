/* ==========================================================================
   Last Exhibit — page behaviour below the stage

   The collection and its inspect dialog, the soundtrack list, the sound
   toggle, install tabs, copy buttons and scroll reveals. The download stage
   is stage.js; the era map is eras.js; the phone is phone.js.
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

  var ERAS = {};
  DATA.eras.forEach(function (e) { ERAS[e.id] = e; });

  /* ======================================================================
     The collection
     ====================================================================== */

  function collection() {
    var grid = $("#cases");
    var filter = $("#coll-filter");
    if (!grid || !filter) return;

    var counts = {};
    DATA.artifacts.forEach(function (a) { counts[a.era] = (counts[a.era] || 0) + 1; });

    DATA.eras.forEach(function (era) {
      if (!counts[era.id]) return;
      var b = document.createElement("button");
      b.className = "chip";
      b.type = "button";
      b.dataset.era = era.id;
      b.setAttribute("aria-pressed", "false");
      b.innerHTML = "<span></span><small>" + counts[era.id] + "</small>";
      filter.appendChild(b);
    });

    DATA.artifacts.forEach(function (a, i) {
      var c = document.createElement("button");
      c.className = "case reveal";
      c.type = "button";
      c.dataset.era = a.era;
      c.style.setProperty("--d", String(i % 8));
      c.setAttribute("aria-haspopup", "dialog");
      c.innerHTML =
        '<span class="case__acc">' + a.value + "</span>" +
        '<img src="' + a.src + '" alt="" loading="lazy" decoding="async" width="64" height="64">' +
        '<span class="case__name">' + a.name + "</span>";
      c.addEventListener("click", function () { openInspect(a, c); });
      grid.appendChild(c);
    });

    function paintChips() {
      $$(".chip", filter).forEach(function (b) {
        if (b.dataset.era !== "all") b.firstChild.textContent = pick(ERAS[b.dataset.era].name);
      });
    }
    paintChips();
    document.addEventListener("langchange", paintChips);

    filter.addEventListener("click", function (e) {
      var b = e.target.closest(".chip");
      if (!b) return;
      $$(".chip", filter).forEach(function (x) { x.setAttribute("aria-pressed", String(x === b)); });
      $$(".case", grid).forEach(function (c) {
        var show = b.dataset.era === "all" || c.dataset.era === b.dataset.era;
        c.classList.toggle("is-hidden", !show);
        if (show) c.classList.add("is-visible");
      });
    });

    inspectDialog();
  }

  var inspect, lastOpener, current;

  function inspectDialog() {
    inspect = $("#inspect");
    $("#inspect-close").addEventListener("click", closeInspect);
    inspect.addEventListener("click", function (e) { if (e.target === inspect) closeInspect(); });
    document.addEventListener("keydown", function (e) {
      if (!inspect.classList.contains("is-open")) return;
      if (e.key === "Escape") closeInspect();
      if (e.key === "Tab") { e.preventDefault(); $("#inspect-close").focus(); }
      if (e.key === "ArrowRight" || e.key === "ArrowLeft") {
        var list = DATA.artifacts;
        var i = list.indexOf(current);
        fillInspect(list[(i + (e.key === "ArrowRight" ? 1 : -1) + list.length) % list.length]);
      }
    });
    document.addEventListener("langchange", function () {
      if (current && inspect.classList.contains("is-open")) fillInspect(current);
    });
  }

  function fillInspect(a) {
    current = a;
    var era = ERAS[a.era];
    $("#inspect-img").src = a.src;
    $("#inspect-img").alt = a.name;
    $("#inspect-acc").textContent = pick(era.name) + " · " + era.year;
    $("#inspect-name").textContent = a.name;
    $("#inspect-note").textContent = a.boss ? t("coll.bossNote") : a.gift ? t("coll.giftNote") : a.big ? t("coll.bigNote") : t("coll.plainNote");
    var rows = [
      [t("coll.value"), a.value + " " + t("coll.coins")],
      [t("coll.darknet"), a.btc + " BTC"]
    ];
    if (a.stack) rows.push([t("coll.stack"), "× " + a.stack]);
    $("#inspect-record").innerHTML = rows.map(function (r) { return "<dt>" + r[0] + "</dt><dd>" + r[1] + "</dd>"; }).join("");
  }

  function openInspect(a, opener) {
    lastOpener = opener;
    fillInspect(a);
    inspect.hidden = false;
    void inspect.offsetWidth;
    inspect.classList.add("is-open");
    document.body.classList.add("is-locked");
    $("#inspect-close").focus();
  }

  function closeInspect() {
    inspect.classList.remove("is-open");
    document.body.classList.remove("is-locked");
    if (lastOpener) lastOpener.focus({ preventScroll: true });
    setTimeout(function () { if (!inspect.classList.contains("is-open")) inspect.hidden = true; }, 360);
  }

  /* ======================================================================
     Soundtrack
     ====================================================================== */

  function soundtrack() {
    var list = $("#tracks");
    if (!list) return;
    var room = $("#listening");

    DATA.tracks.forEach(function (tr) {
      var li = document.createElement("li");
      li.className = "track";
      li.dataset.id = tr.id;
      li.innerHTML =
        '<button class="track__play" type="button" aria-pressed="false"><svg aria-hidden="true"><use href="#i-play"/></svg><span class="sr-only"></span></button>' +
        '<span><span class="track__title"></span><span class="track__where"></span></span>' +
        '<span class="track__time">' + mmss(tr.dur) + "</span>" +
        '<span class="track__bar" aria-hidden="true"></span>';
      $(".track__play", li).addEventListener("click", function () {
        if (AUDIO.chosen === tr.id && AUDIO.current === tr.id) AUDIO.release();
        else AUDIO.choose(tr.id, { restart: true, once: true });
      });
      list.appendChild(li);
    });

    function paintText() {
      $$(".track", list).forEach(function (li) {
        var tr = AUDIO.track(li.dataset.id);
        $(".track__title", li).textContent = pick(tr.title);
        $(".track__where", li).textContent = pick(tr.where);
        $(".sr-only", li).textContent = t(li.dataset.playing === "true" ? "listen.pause" : "listen.play") + ": " + pick(tr.title);
      });
    }
    paintText();
    document.addEventListener("langchange", paintText);

    document.addEventListener("trackchange", function (e) {
      $$(".track", list).forEach(function (li) {
        var on = e.detail.playing && e.detail.id === li.dataset.id && AUDIO.chosen === li.dataset.id;
        li.dataset.playing = String(on);
        var btn = $(".track__play", li);
        btn.setAttribute("aria-pressed", String(on));
        $("use", btn).setAttribute("href", on ? "#i-pause" : "#i-play");
        if (!on) {
          li.style.setProperty("--p", 0);
          $(".track__time", li).textContent = mmss(AUDIO.track(li.dataset.id).dur);
        }
      });
      room.classList.toggle("is-playing", !!(e.detail.playing && AUDIO.chosen));
      paintText();
    });

    document.addEventListener("tracktime", function (e) {
      var li = $('.track[data-id="' + e.detail.id + '"]', list);
      if (!li || li.dataset.playing !== "true") return;
      li.style.setProperty("--p", e.detail.duration ? (e.detail.current / e.detail.duration).toFixed(4) : 0);
      $(".track__time", li).textContent = mmss(e.detail.current) + " / " + mmss(e.detail.duration);
    });
  }

  function mmss(sec) {
    sec = Math.max(0, Math.floor(sec || 0));
    return Math.floor(sec / 60) + ":" + (sec % 60 < 10 ? "0" : "") + (sec % 60);
  }

  /* ======================================================================
     Sound toggle — plays the main menu theme, and lets the jumps make noise
     ====================================================================== */

  function soundToggle() {
    var btn = $("#sound-toggle");
    var np = $("#now-playing");
    var title = $("#now-playing-title");

    AUDIO.setAmbient("trailer");
    btn.addEventListener("click", function () { AUDIO.toggle(); });
    document.addEventListener("soundchange", function (e) {
      btn.setAttribute("aria-pressed", String(e.detail.enabled));
    });

    var last = null;
    function paint() {
      var tr = last && last.id ? AUDIO.track(last.id) : null;
      np.classList.toggle("is-on", !!(tr && last.playing && AUDIO.enabled));
      if (tr) title.textContent = pick(tr.title);
    }
    document.addEventListener("trackchange", function (e) { last = e.detail; paint(); });
    document.addEventListener("langchange", paint);
  }

  /* ======================================================================
     Install tabs, copy buttons, header, reveals
     ====================================================================== */

  function tabs() {
    var list = $(".tabs");
    if (!list) return;
    var buttons = $$("[role='tab']", list);
    function select(btn, focus) {
      buttons.forEach(function (b) {
        var on = b === btn;
        b.setAttribute("aria-selected", String(on));
        b.tabIndex = on ? 0 : -1;
        document.getElementById(b.getAttribute("aria-controls")).hidden = !on;
      });
      if (focus) btn.focus();
    }
    buttons.forEach(function (b, i) {
      b.addEventListener("click", function () { select(b); });
      b.addEventListener("keydown", function (e) {
        var d = e.key === "ArrowRight" ? 1 : e.key === "ArrowLeft" ? -1 : 0;
        if (d) select(buttons[(i + d + buttons.length) % buttons.length], true);
      });
    });
    var mine = document.getElementById("tab-" + window.LE_PLATFORM);
    if (mine) select(mine);
  }

  function copyButtons() {
    document.addEventListener("click", function (e) {
      var b = e.target.closest("[data-copy], [data-copy-text]");
      if (!b) return;
      var text = b.dataset.copyText || ($("code", b.parentElement) || {}).textContent || "";
      var done = function () {
        b.textContent = t("dl.copied");
        setTimeout(function () { b.textContent = t("ui.copy"); }, 1400);
      };
      if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text).then(done, function () {});
      } else {
        var ta = document.createElement("textarea");
        ta.value = text;
        ta.style.cssText = "position:fixed;opacity:0";
        document.body.appendChild(ta);
        ta.select();
        try { document.execCommand("copy"); done(); } catch (err) { /* nothing to do */ }
        ta.remove();
      }
    });
  }

  function header() {
    var hud = $("#hud");
    var stage = $("#top");
    function paint() {
      var y = window.scrollY;
      hud.classList.toggle("is-scrolled", y > 40);
      // The header's download button only shows once the plinths are off screen
      hud.classList.toggle("is-past-stage", y > stage.offsetHeight - 80);
    }
    paint();
    window.addEventListener("scroll", paint, { passive: true });
  }

  function reveals() {
    var targets = $$(".reveal");
    if (!("IntersectionObserver" in window) || reduced.matches) {
      targets.forEach(function (el) { el.classList.add("is-visible"); });
      return;
    }
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (!e.isIntersecting) return;
        e.target.classList.add("is-visible");
        io.unobserve(e.target);
      });
    }, { rootMargin: "0px 0px -8% 0px", threshold: 0.08 });
    targets.forEach(function (el) { io.observe(el); });
  }

  function boot() {
    collection();
    soundtrack();
    soundToggle();
    tabs();
    copyButtons();
    header();
    reveals();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
