/* ==========================================================================
   Last Exhibit — Sprachumschaltung

   Deutsch steht im HTML und ist die Quelle. Beim Start merkt sich das Skript
   den Originaltext jedes Elements mit data-i18n="key"; ein Wechsel auf
   Englisch setzt die Übersetzung von unten ein, zurück auf Deutsch stellt
   das Original wieder her. Fehlt ein Schlüssel, bleibt es deutsch.

   Attribute: data-i18n-alt, data-i18n-aria-label, data-i18n-content,
   data-i18n-title. Skripte nutzen LE_I18N.t(key) für eigene Strings und
   LE_I18N.pick({ de, en }) für Daten, und hören auf "langchange".
   ========================================================================== */

(function () {
  "use strict";

  var STORAGE_KEY = "lastexhibit.lang";
  var DEFAULT = "de";

  /* Strings, die nur Skripte benutzen. */
  var SCRIPT = {
    de: {
      "stage.download": "Download",
      "stage.webName": "Browser",
      "stage.metaPlay": "Jetzt spielen",
      "stage.metaSoon": "Bald",
      "stage.noBuild": "Noch keine Builds hochgeladen",
      "stage.pickOne": "Plattform wählen",
      "stage.sayHint": "Der hier ist deiner.",
      "stage.sayWaiting": "Noch nichts zu holen…",
      "stage.sayDownload": "Hab ihn! Lädt…",
      "stage.sayPlay": "Ab in den Browser!",
      "stage.sayEmpty": "Leer. Noch nicht hochgeladen.",
      "dl.copied": "Kopiert",
      "ui.copy": "Kopieren",
      "phone.messages": "Nachrichten",
      "phone.settings": "Einstellungen",
      "phone.shopHint": "Freischaltungen und Upgrades, so wie im Spiel:",
      "phone.msg1": "Pickup your Upgrade",
      "phone.msgNote": "Die einzige Nachricht, die dir das Spiel je schickt.",
      "phone.account": "Dein Konto",
      "phone.transactions": "Transaktionen",
      "phone.coins": "Münzen",
      "phone.shards": "Zeitsplitter",
      "phone.btc": "Bitcoin",
      "phone.visitors": "Besucher pro Tag:",
      "phone.reputation": "Ruf des Museums:",
      "phone.ticket": "Preis pro Ticket:",
      "phone.income": "Tageseinnahmen:",
      "phone.museumNote": "Beispielwerte nach ein paar guten Nächten.",
      "phone.settingsBody": "Audio: Gesamt, Musik, Effekte. Tastenbelegung für zehn Aktionen. Und ein Knopf, der dein ganzes Spiel zurücksetzt.",
      "phone.torIntro": "GUTHABEN",
      "phone.torSell": "// VERKAUFEN",
      "phone.torBuy": "// KAUFEN",
      "phone.torSellEmpty": "Keine verkaufbaren Artefakte in der Tasche.",
      "phone.torSee": "Alle Angebote stehen neben dem Handy.",
      "phone.flappyHint": "Tippen oder Leertaste. Alle 10 Punkte gibt es im Spiel 1 Münze.",
      "phone.flappyStart": "Tippen zum Starten",
      "phone.flappyOver": "Game Over! Punkte: ",
      "phone.flappyBest": "Rekord: "
    },
    en: {
      "stage.download": "Download",
      "stage.webName": "Browser",
      "stage.metaPlay": "Play now",
      "stage.metaSoon": "Soon",
      "stage.noBuild": "No builds uploaded yet",
      "stage.pickOne": "Pick a platform",
      "stage.sayHint": "This one's yours.",
      "stage.sayWaiting": "Nothing to take yet…",
      "stage.sayDownload": "Got it! Downloading…",
      "stage.sayPlay": "To the browser!",
      "stage.sayEmpty": "Empty. Not uploaded yet.",
      "dl.copied": "Copied",
      "ui.copy": "Copy",
      "phone.messages": "Messages",
      "phone.settings": "Settings",
      "phone.shopHint": "Unlocks and upgrades, as listed in the game:",
      "phone.msg1": "Pickup your Upgrade",
      "phone.msgNote": "The only text the game ever sends you.",
      "phone.account": "Your Account",
      "phone.transactions": "Transactions",
      "phone.coins": "Coins",
      "phone.shards": "Time shards",
      "phone.btc": "Bitcoin",
      "phone.visitors": "Visitors per day:",
      "phone.reputation": "Museums Reputation:",
      "phone.ticket": "Price per Ticket:",
      "phone.income": "Your Daily Income:",
      "phone.museumNote": "Example numbers after a few good nights.",
      "phone.settingsBody": "Audio: Master, Music, SFX. Keybinds for ten actions. And a button that resets your whole game.",
      "phone.torIntro": "BALANCE",
      "phone.torSell": "// SELL",
      "phone.torBuy": "// BUY",
      "phone.torSellEmpty": "No sellable artifacts in your bag.",
      "phone.torSee": "The full list is next to the phone.",
      "phone.flappyHint": "Tap or press Space. Every 10 points is 1 coin in the game.",
      "phone.flappyStart": "Tap to start",
      "phone.flappyOver": "Game Over! Score: ",
      "phone.flappyBest": "Best: "
    }
  };

  /* Seitentexte auf Englisch. Schlüssel = data-i18n im HTML. */
  var EN = {
    "meta.title": "Last Exhibit - free download",
    "meta.description": "Last Exhibit is a free pixel game from a school project. You run a museum and fill it with things you steal from the past. For Windows, macOS, Linux and the browser.",
    "nav.skip": "Skip to the download",

    "hud.get": "Download",
    "hud.sound": "Music",
    "hud.lang": "Language",
    "ui.copy": "Copy",

    "stage.line": "You run a museum and fill it with things you steal from the past.",
    "stage.downloads": "Downloads",
    "stage.web": "Browser",
    "stage.noBuild": "No builds uploaded yet",
    "stage.help": "Won't start?",

    "how.title": "What is this?",
    "how.p1": "You're David. You bought an old museum that's about to go bankrupt, and behind a wall in the basement there's a time machine.",
    "how.p2": "At night you jump into the past, to 1965, 1943, 1600 or around 1200. You take whatever you can carry and get out before your 60 seconds run out. If you die there, everything you collected that night is gone.",
    "how.p3": "During the day you put the loot in the showcases and visitors pay to see it. With the money you unlock more years. At some point there's a knight in a castle who really doesn't want you there.",
    "how.p4": "Four levels, four bosses, four hours of music and a phone with Flappy Bird on it. The game itself is in English.",

    "dark.title": "Your phone",
    "dark.lede": "In the game you open it with P. It has the shop where you unlock new levels, your bank, your museum's numbers, a darknet app and Flappy Bird. You can click around on this one too.",
    "dark.lede2": "The darknet app costs 500 coins in the game. You sell artifacts there for bitcoin and buy stuff that helps you survive the next night:",
    "phone.messages": "Messages",
    "phone.settings": "Settings",
    "phone.back": "‹ Back",

    "help.title": "Installing",
    "inst.lede": "We didn't pay for code signing, so Windows and macOS will warn you the first time you open it. That's normal.",
    "inst.os": "Operating system",
    "inst.w1": "Unzip it. <code>LastExhibit.exe</code> and <code>LastExhibit.pck</code> have to stay in the same folder.",
    "inst.w2": "Open <code>LastExhibit.exe</code>. If a blue \"Windows protected your PC\" box shows up, click <b>More info</b> and then <b>Run anyway</b>.",
    "inst.m1": "Unzip it and drag <code>Last Exhibit.app</code> into Applications.",
    "inst.m2": "Right-click the app, choose <b>Open</b>, then <b>Open</b> again. On newer macOS versions go to <b>System Settings → Privacy &amp; Security</b> and click <b>Open Anyway</b>.",
    "inst.m3": "If it says the app is damaged, paste this into Terminal once:",
    "inst.l1": "Unzip it. <code>LastExhibit.x86_64</code> and <code>LastExhibit.pck</code> have to stay together.",
    "inst.l2": "Then:",

    "ctrl.title": "Controls",
    "ctrl.lede": "No controller support yet. You can change the keys in the phone's settings.",
    "ctrl.move": "Walk",
    "ctrl.jump": "Jump",
    "ctrl.space": "Space",
    "ctrl.melee": "Hit",
    "ctrl.lmb": "Left click",
    "ctrl.shoot": "Shoot",
    "ctrl.rmb": "Right click",
    "ctrl.interact": "Pick up",
    "ctrl.climb": "Ladders",
    "ctrl.phone": "Phone",
    "ctrl.items": "Items",
    "ctrl.menu": "Pause",

    "faq.title": "Other questions",
    "faq.q1": "Does it cost anything?",
    "faq.a1": "No. It's a school project.",
    "faq.q2": "Will it run on my laptop?",
    "faq.a2": "Probably. It uses Godot's simple renderer, so anything with OpenGL 3.3 should work. The browser version needs WebGL 2.",
    "faq.q3": "What age is it for?",
    "faq.a3": "There's no official USK rating. The game has fighting with swords and guns, in pixels and without blood.",
    "faq.q4": "Phone?",
    "faq.a4": "No, you need a keyboard.",
    "faq.q6": "Still doesn't start?",
    "faq.a6": "Ask in our <a href=\"https://discord.gg/DU29ufhM8F\" rel=\"noopener\">Discord</a> and tell us which system you're on.",

    "cred.title": "Made by",
    "cred.alex": "code, game design, all the music",
    "cred.paul": "code, game design, graphics",
    "cred.johannes": "code, game design, graphics",
    "cred.fabian": "code, game design, graphics",
    "cred.thanks": "Thanks to Prager, Claude / Gemini and you for playing. Some sprites are free packs from CraftPix and GandalfHardcore.",
    "legal.privacy": "Privacy"
  };

  var ATTRS = ["alt", "aria-label", "content", "title"];

  function readStored() {
    try { return localStorage.getItem(STORAGE_KEY); } catch (e) { return null; }
  }
  function store(lang) {
    try { localStorage.setItem(STORAGE_KEY, lang); } catch (e) { /* privater Modus */ }
  }

  var initial = readStored();
  if (initial !== "en" && initial !== "de") initial = DEFAULT;

  var api = {
    lang: initial,

    t: function (key) {
      var table = SCRIPT[api.lang] || SCRIPT[DEFAULT];
      if (key in table) return table[key];
      if (key in SCRIPT[DEFAULT]) return SCRIPT[DEFAULT][key];
      return key;
    },

    pick: function (pair) {
      if (pair == null) return "";
      if (typeof pair === "string") return pair;
      return pair[api.lang] != null ? pair[api.lang] : pair.de;
    },

    set: function (lang) {
      if (lang !== "en" && lang !== "de") return;
      api.lang = lang;
      store(lang);
      apply();
      document.dispatchEvent(new CustomEvent("langchange", { detail: { lang: lang } }));
    }
  };

  /* Deutsch so merken, wie es im HTML steht */
  function original(el, slot, read) {
    var key = "leOrig" + slot;
    if (!(key in el.dataset)) el.dataset[key] = read();
    return el.dataset[key];
  }

  function apply(root) {
    var scope = root || document;
    var en = api.lang === "en";
    document.documentElement.lang = api.lang;

    scope.querySelectorAll("[data-i18n]").forEach(function (el) {
      var de = original(el, "Html", function () { return el.innerHTML; });
      var next = en && EN[el.dataset.i18n] != null ? EN[el.dataset.i18n] : de;
      if (el.innerHTML !== next) el.innerHTML = next;
    });

    ATTRS.forEach(function (attr) {
      var data = "i18n" + attr.replace(/(^|-)([a-z])/g, function (m, d, c) { return c.toUpperCase(); });
      scope.querySelectorAll("[data-i18n-" + attr + "]").forEach(function (el) {
        var de = original(el, attr.replace("-", ""), function () { return el.getAttribute(attr) || ""; });
        var k = el.dataset[data];
        el.setAttribute(attr, en && EN[k] != null ? EN[k] : de);
      });
    });

    document.querySelectorAll("[data-lang]").forEach(function (btn) {
      btn.setAttribute("aria-pressed", String(btn.dataset.lang === api.lang));
    });
  }

  api.apply = apply;

  /* Eine Seite kann eigene englische Texte nachreichen (play.html) */
  api.extend = function (dict) {
    Object.keys(dict).forEach(function (k) { EN[k] = dict[k]; });
    if (document.readyState !== "loading") apply();
  };

  window.LE_I18N = api;

  function boot() {
    apply();
    document.querySelectorAll("[data-lang]").forEach(function (btn) {
      btn.addEventListener("click", function () { api.set(btn.dataset.lang); });
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
