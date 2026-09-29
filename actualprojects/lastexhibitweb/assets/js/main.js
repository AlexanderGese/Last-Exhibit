/* ==========================================================================
   Last Exhibit — Kleinkram

   Musikschalter, Reiter bei der Installationshilfe, Kopieren-Knöpfe und die
   Kopfzeile. Der Download-Bereich steckt in stage.js, das Handy in phone.js.
   ========================================================================== */

(function () {
  "use strict";

  var AUDIO = window.LE_AUDIO;
  var I18N = window.LE_I18N;
  var t = function (k) { return I18N.t(k); };
  var pick = function (p) { return I18N.pick(p); };
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };

  /* Musik: der Titelbildschirm-Track, bis jemand ihn ausschaltet */
  function soundToggle() {
    var btn = $("#sound-toggle");
    var np = $("#now-playing");
    var title = $("#now-playing-title");
    if (!btn) return;

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
        try { document.execCommand("copy"); done(); } catch (err) { /* egal */ }
        ta.remove();
      }
    });
  }

  function header() {
    var hud = $("#hud");
    var stage = $("#top");
    if (!hud || !stage) return;
    function paint() {
      var y = window.scrollY;
      hud.classList.toggle("is-scrolled", y > 40);
      // Der Download-Knopf oben erscheint erst, wenn die Säulen weg sind
      hud.classList.toggle("is-past-stage", y > stage.offsetHeight - 80);
    }
    paint();
    window.addEventListener("scroll", paint, { passive: true });
  }

  function boot() {
    soundToggle();
    tabs();
    copyButtons();
    header();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
