/* ==========================================================================
   Last Exhibit — browser player
   The iframe only gets a source when a web export has actually been copied
   into game/. Otherwise the page says so instead of showing a broken canvas.
   ========================================================================== */

(function () {
  "use strict";

  function boot() {
    var manifest = window.LE_BUILDS || {};
    var playable = document.getElementById("playable");
    var unavailable = document.getElementById("unavailable");
    var frame = document.getElementById("game-frame");
    var holder = document.getElementById("play-frame");
    var fullscreen = document.getElementById("go-fullscreen");

    var ready = !!(manifest.web && manifest.web.available);
    playable.hidden = !ready;
    unavailable.hidden = ready;

    if (!ready) return;

    frame.src = "game/index.html";
    frame.addEventListener("load", function () {
      try { frame.contentWindow.focus(); } catch (e) { /* cross-origin */ }
    });

    fullscreen.addEventListener("click", function () {
      if (document.fullscreenElement) {
        document.exitFullscreen();
      } else if (holder.requestFullscreen) {
        holder.requestFullscreen().then(function () {
          try { frame.contentWindow.focus(); } catch (e) { /* ignore */ }
        });
      }
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
