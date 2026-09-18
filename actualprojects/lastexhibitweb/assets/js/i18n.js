/* ==========================================================================
   Last Exhibit — language switching

   English lives in the HTML and is the source of truth. On boot, every
   element with data-i18n="key" has its original markup remembered; switching
   to German swaps in the dictionary below, switching back restores the
   original. A key missing here simply stays English.

   Attributes: data-i18n-alt, data-i18n-aria-label, data-i18n-content,
   data-i18n-title. Scripts use LE_I18N.t(key) for their own strings and
   LE_I18N.pick({ en, de }) for data, and listen for "langchange".
   ========================================================================== */

(function () {
  "use strict";

  var STORAGE_KEY = "lastexhibit.lang";

  /* Strings that only scripts use. English and German both live here. */
  var SCRIPT = {
    en: {
      "dl.download": "Download",
      "dl.play": "Play now",
      "dl.unavailable": "Not in the collection yet",
      "dl.pending": "—",
      "dl.copied": "Copied",
      "ui.copy": "Copy",
      "dn.toDay": "Switch to daytime",
      "dn.toNight": "Switch to night",
      "dn.open": "Open",
      "dn.closed": "Closed",
      "coll.value": "Museum value",
      "coll.darknet": "Darknet pays",
      "coll.era": "Found in",
      "coll.stack": "Carry up to",
      "coll.boss": "Boss drop",
      "coll.bossNote": "Only drops when the boss of this era goes down.",
      "coll.giftNote": "Dmitri gives it to you, depending on how the conversation goes.",
      "coll.bigNote": "A big piece. It takes a large showcase.",
      "coll.plainNote": "Lying around somewhere in the level, glowing faintly.",
      "coll.coins": "coins",
      "eras.place": "Where",
      "eras.unlock": "Unlock",
      "eras.boss": "Boss",
      "eras.health": "Health",
      "eras.attacks": "Attacks",
      "eras.shards": "Time shards",
      "eras.sealed": "Sealed",
      "eras.nothing": "No artifacts. Nobody has been.",
      "floor.hall": "The hall",
      "floor.gallery": "Gallery",
      "floor.cellar": "Basement",
      "floor.machine": "The machine",
      "floor.eras": "The eras",
      "floor.darknet": "The darknet",
      "floor.listening": "Soundtrack",
      "floor.dawn": "Downloads",
      "floor.credits": "Credits",
      "lift.up": "▲ up",
      "lift.down": "▼ down",
      "lift.night": "Night",
      "lift.day": "Day",
      "cellar.line1": "Second floor. Where the showcases are.",
      "cellar.line2": "First floor. More of them. All empty.",
      "cellar.line3": "Ground floor. The ticket desk nobody sits at.",
      "cellar.line4": "Basement. Something is humming behind the wall.",
      "machine.pulled": "The machine is running. Scroll down.",
      "herrk": "…",
      "herrk.look": "He looks up.",
      "phone.messages": "Messages",
      "phone.settings": "Settings",
      "phone.shopHint": "Unlocks and upgrades, as they're listed in the game:",
      "phone.msg1": "Pickup your Upgrade",
      "phone.msgNote": "It's the only text the game ever sends you. Nobody else has this number.",
      "phone.account": "Your Account",
      "phone.transactions": "Transactions",
      "phone.coins": "Coins",
      "phone.shards": "Time shards",
      "phone.btc": "Bitcoin",
      "phone.visitors": "Visitors per day:",
      "phone.reputation": "Museums Reputation:",
      "phone.ticket": "Price per Ticket:",
      "phone.income": "Your Daily Income:",
      "phone.museumNote": "Example numbers after a good few nights.",
      "phone.settingsBody": "Audio: Master, Music, SFX. Keybinds for ten actions. And a button that resets your whole game.",
      "phone.torIntro": "BALANCE",
      "phone.torSell": "// SELL",
      "phone.torBuy": "// BUY",
      "phone.torSellEmpty": "No sellable artifacts in your bag.",
      "phone.torSee": "The full listings are below the phone.",
      "phone.flappyHint": "Tap or press Space. Every 10 points is 1 coin in the game.",
      "phone.flappyStart": "Tap to start",
      "phone.flappyOver": "Game Over! Score: ",
      "phone.flappyBest": "Best: ",
      "listen.play": "Play",
      "listen.pause": "Pause",
      "np.label": "Playing",
      "sound.blocked": "Your browser blocked audio. Click Sound again."
    },
    de: {
      "dl.download": "Herunterladen",
      "dl.play": "Jetzt spielen",
      "dl.unavailable": "Noch nicht in der Sammlung",
      "dl.pending": "—",
      "dl.copied": "Kopiert",
      "ui.copy": "Kopieren",
      "dn.toDay": "Zum Tag wechseln",
      "dn.toNight": "Zur Nacht wechseln",
      "dn.open": "Geöffnet",
      "dn.closed": "Geschlossen",
      "coll.value": "Wert fürs Museum",
      "coll.darknet": "Darknet zahlt",
      "coll.era": "Gefunden in",
      "coll.stack": "Trägst du bis zu",
      "coll.boss": "Boss-Beute",
      "coll.bossNote": "Fällt nur, wenn der Boss dieser Epoche besiegt ist.",
      "coll.giftNote": "Dmitri schenkt es dir, je nachdem, wie das Gespräch läuft.",
      "coll.bigNote": "Ein großes Stück. Braucht eine große Vitrine.",
      "coll.plainNote": "Liegt irgendwo im Level und leuchtet schwach.",
      "coll.coins": "Münzen",
      "eras.place": "Ort",
      "eras.unlock": "Freischaltung",
      "eras.boss": "Boss",
      "eras.health": "Leben",
      "eras.attacks": "Angriffe",
      "eras.shards": "Zeitsplitter",
      "eras.sealed": "Versiegelt",
      "eras.nothing": "Keine Artefakte. Hier war noch niemand.",
      "floor.hall": "Die Halle",
      "floor.gallery": "Galerie",
      "floor.cellar": "Keller",
      "floor.machine": "Die Maschine",
      "floor.eras": "Die Epochen",
      "floor.darknet": "Das Darknet",
      "floor.listening": "Soundtrack",
      "floor.dawn": "Downloads",
      "floor.credits": "Abspann",
      "lift.up": "▲ hoch",
      "lift.down": "▼ runter",
      "lift.night": "Nacht",
      "lift.day": "Tag",
      "cellar.line1": "Zweiter Stock. Hier stehen die Vitrinen.",
      "cellar.line2": "Erster Stock. Noch mehr davon. Alle leer.",
      "cellar.line3": "Erdgeschoss. Die Kasse, an der niemand sitzt.",
      "cellar.line4": "Keller. Hinter der Wand summt etwas.",
      "machine.pulled": "Die Maschine läuft. Scroll weiter.",
      "herrk": "…",
      "herrk.look": "Er schaut auf.",
      "phone.messages": "Nachrichten",
      "phone.settings": "Einstellungen",
      "phone.shopHint": "Freischaltungen und Upgrades, so wie sie im Spiel stehen:",
      "phone.msg1": "Pickup your Upgrade",
      "phone.msgNote": "Die einzige Nachricht, die dir das Spiel je schickt. Sonst hat niemand diese Nummer.",
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
      "phone.torSee": "Alle Angebote stehen unter dem Handy.",
      "phone.flappyHint": "Tippen oder Leertaste. Alle 10 Punkte gibt es im Spiel 1 Münze.",
      "phone.flappyStart": "Tippen zum Starten",
      "phone.flappyOver": "Game Over! Punkte: ",
      "phone.flappyBest": "Rekord: ",
      "listen.play": "Abspielen",
      "listen.pause": "Pause",
      "np.label": "Läuft",
      "sound.blocked": "Dein Browser hat den Ton blockiert. Klick nochmal auf Ton."
    }
  };

  /* Page copy in German. Keys match data-i18n attributes in index.html. */
  var DE = {
    "meta.title": "Last Exhibit — tagsüber ein Museum, nachts ein Raubzug",
    "meta.description": "Ein 2D-Pixel-Art-Spiel über einen Geschichtsstudenten, der ein bankrottes Museum kauft, im Keller eine Zeitmaschine findet und die Vitrinen füllt, indem er 1965, 1943, 1600 und 1200 ausraubt. Kostenlos für Windows, macOS, Linux und den Browser.",
    "nav.skip": "Direkt zu den Downloads",

    "cold.l1": "Dem historischen Museum der Stadt droht die Pleite.",
    "cold.l2": "Heute habe ich das alte Museum gekauft.",
    "cold.l3": "Aber im Keller ist etwas.",
    "cold.hint": "Der Ton ist aus. Du kannst ihn oben einschalten.",
    "cold.skip": "Intro überspringen",

    "hud.get": "Spiel holen",
    "hud.sound": "Ton",
    "hud.lang": "Sprache",
    "lift.label": "Stockwerke",
    "lift.night": "Nacht",
    "np.label": "Läuft",

    "floor.hall": "Die Halle",
    "floor.gallery": "Galerie",
    "floor.cellar": "Keller",
    "floor.machine": "Die Maschine",
    "floor.eras": "Die Epochen",
    "floor.darknet": "Das Darknet",
    "floor.listening": "Soundtrack",
    "floor.dawn": "Downloads",

    "hall.artAlt": "Eine dunkle Museumshalle. Eine gesprungene Vitrine leuchtet bernsteinfarben, ein blauer Riss zieht sich über den Boden darauf zu.",
    "hall.l1": "Er hat ein Museum gekauft, das sonst keiner wollte.",
    "hall.l2": "Tagsüber zahlen Besucher, um zu sehen, was in den Vitrinen liegt.",
    "hall.l3": "Nachts geht er es stehlen.",
    "hall.download": "Kostenlos herunterladen",
    "hall.play": "Im Browser spielen",
    "hall.m1": "2D-Pixel-Art · Einzelspieler",
    "hall.m2": "4 Epochen · 4 Bosse · 35 Artefakte",
    "hall.m3": "Windows · macOS · Linux · Browser",
    "hall.m4": "Gebaut in Godot 4.6 von vier Schülern",

    "gallery.tag": "Erster Stock · So läuft ein Tag",
    "gallery.title": "Fünfundvierzig Vitrinen, und alle sind leer.",
    "gallery.lede": "Das Museum stand kurz vor dem Abriss, als David A. unterschrieb. Es legal zu füllen, würde ein Leben dauern. Im Keller hat er einen schnelleren Weg gefunden.",
    "gallery.switch": "Zum Tag wechseln",
    "gallery.n1": "Die Türen schließen. Die Ticketeinnahmen des Tages kommen rein.",
    "gallery.n2": "Mit dem Aufzug in den Keller. Auf der Karte der Maschine eine Nadel wählen.",
    "gallery.n3": "So lange lässt dich die Vergangenheit bleiben. Artefakte und Zeitsplitter einsammeln, den Boss besiegen, wenn du kannst.",
    "gallery.n4": "Der Timer läuft ab und du wirst zurückgezogen. Stirbst du dort, bleibt deine Tasche zurück.",
    "gallery.d1": "Stell aus, was du gestohlen hast. Jedes Artefakt in einer Vitrine bringt Ruf.",
    "gallery.d2": "Besucher kommen: zehn, plus dein Ruf mal dein Level.",
    "gallery.d3": "Das Ticket kostet 5 plus ein Hundertstel von allem, was ausgestellt ist. Je besser die Beute, desto teurer der Eintritt.",
    "gallery.d4": "Gib es auf dem Handy aus: neue Epochen, mehr Zeit in der Vergangenheit und eine App, die du nicht haben solltest.",
    "gallery.nightAlt": "Die Museumshalle nachts in blauem Licht, mit einer gesprungenen Vitrine, in der eine Uhr leuchtet",
    "gallery.closed": "Geschlossen",

    "coll.tag": "Die Sammlung",
    "coll.title": "Alles, was sich zu stehlen lohnt.",
    "coll.lede": "Alle 35 Artefakte im Spiel, mit dem Wert, den das Museum ihnen beimisst. Wähl eins aus, um zu sehen, woher es stammt und was das Darknet dafür zahlt.",
    "coll.filter": "Nach Epoche filtern",
    "coll.all": "Alle",
    "ui.close": "Schließen",
    "ui.copy": "Kopieren",

    "cellar.tag": "Keller",
    "cellar.s1": "Liebes Tagebuch. Heute habe ich das alte Museum gekauft.<small>S. 1</small>",
    "cellar.s2": "Es braucht viel Arbeit, aber ich glaube, es ist zu retten.<small>S. 1</small>",
    "cellar.s3": "Aber im Keller ist etwas.<small>S. 2</small>",
    "cellar.s4": "Es sieht fast so aus, als käme es aus der Zukunft…",
    "cellar.s5": "Jetzt schreib die Geschichte selbst.",
    "cellar.line0": "Der Aufzug hat nur vier Knöpfe. Im Keller wartet ein Paket.",

    "machine.tag": "Hinter der Kellerwand",
    "machine.title": "Sie war schon hier, als er das Haus gekauft hat.",
    "machine.note": "Bitte nicht benutzen.",
    "machine.noteBy": "— an den Rahmen geklebt, ohne Unterschrift",
    "machine.lede": "Niemand weiß, wer sie gebaut hat oder was aus ihm geworden ist. Sie öffnet eine Karte mit ein paar Nadeln und einem Schieber voller Jahreszahlen. Sie funktioniert noch.",
    "machine.leverSr": "Hebel ziehen",
    "machine.lever": "Zieh den Hebel, um hindurchzugehen.",
    "machine.after": "Er hat den Zettel gelesen. Kurz gezögert. Und sie trotzdem benutzt.",

    "eras.tag": "Die Zeitmaschine",
    "eras.title": "Vier Nächte kannst du erreichen. Eine nicht.",
    "eras.lede": "Das ist die Karte der Maschine selbst. Jede Nadel öffnet ein handgebautes Level mit eigenem Boss, eigenen Leuten und eigener Musik. Freigeschaltet wird mit Zeitsplittern, und die findest du nur in der Vergangenheit.",
    "eras.map": "Weltkarte",
    "eras.choose": "Epoche wählen",
    "eras.status": "Ziel",
    "eras.stay": "Erlaubte Zeit",
    "eras.bossLabel": "Boss",
    "eras.loot": "Artefakte zum Mitnehmen",
    "eras.levelTrack": "Level-Musik",
    "eras.bossTrack": "Boss-Musik",

    "dark.tag": "Davids Handy",
    "dark.title": "Manches passt in keine Vitrine.",
    "dark.lede": "Alles läuft über das Handy: der Shop mit den neuen Epochen, die Bank, die Nachrichten. Kauf die Darknet-App für 500 Münzen, und eine zweite Wirtschaft öffnet sich. Gestohlene Geschichte rein, Bitcoin raus.",
    "dark.try": "Dieses Handy funktioniert. Probier die Apps aus.",
    "phone.messages": "Nachrichten",
    "phone.settings": "Einstellungen",
    "phone.back": "‹ Start",
    "dark.roomAlt": "Ein blauer Ziegelkeller mit fünf leeren Marktständen unter Wandlaternen und einem Stuhl in der Ecke",
    "dark.ledgerTitle": "Angebote",
    "dark.ledgerRole": "Neun Waren, bezahlt in Bitcoin. Die verdienst du, indem du hier Artefakte verkaufst, für 7 % dessen, was das Museum für ihren Wert hält.",
    "dark.ledgerNote": "Der Overclock Chip kostet mehr, als du mit jeder Samurai-Maske verdienst, die du je finden wirst. Plane entsprechend.",

    "listen.tag": "Soundtrack",
    "listen.title": "Jede Epoche hat zwei Stücke. Eins zum Schleichen, eins für den Boss.",
    "listen.lede": "Fünfzehn Tracks von Alexander Gese, direkt aus den Spieldateien, inklusive der zwei, die für das Inka-Level geschrieben wurden, das es noch nicht gibt.",

    "dawn.tag": "Erdgeschoss · 06:00",
    "dawn.title": "Das Museum hat geöffnet.",
    "dawn.lede": "Last Exhibit ist kostenlos. Kein Launcher, kein Konto, nichts zu unterschreiben. Nimm den Build für deinen Computer oder spiel direkt hier im Browser.",
    "dawn.hours": "Öffnungszeiten",
    "dawn.signTitle": "Öffnungszeiten",
    "dawn.signDay": "Tag · 06:00–22:00 · Besucher",
    "dawn.signNight": "Nacht · 22:00–06:00 · für die Öffentlichkeit geschlossen",
    "dawn.open": "Jetzt geöffnet",
    "dawn.recommended": "Empfohlen für diesen Computer",

    "dl.download": "Herunterladen",
    "dl.yours": "Dieser Computer",
    "dl.empty": "Vitrine leer",
    "dl.file": "Datei",
    "dl.size": "Größe",
    "dl.added": "Hinzugefügt",
    "dl.needs": "Braucht",
    "dl.winFile": ".zip · x86_64",
    "dl.macFile": ".zip · Universal",
    "dl.linuxFile": ".zip · x86_64",
    "dl.webName": "Browser",
    "dl.webFile": "Nichts zu installieren",
    "dl.webNeeds": "WebGL 2, eine Tastatur",

    "inst.title": "Erster Start",
    "inst.lede": "Die Builds sind nicht signiert. Das ist bei einem Schulprojekt normal und heißt, dass dein System einmal fragt, ob du der Datei vertraust. So sagst du Ja.",
    "inst.os": "Betriebssystem",
    "inst.w1": "Entpack den Download. Lass <code>LastExhibit.exe</code> und <code>LastExhibit.pck</code> im selben Ordner.",
    "inst.w2": "Öffne <code>LastExhibit.exe</code>. Wenn SmartScreen „Der Computer wurde durch Windows geschützt“ meldet, klick auf <b>Weitere Informationen</b> und dann auf <b>Trotzdem ausführen</b>.",
    "inst.w3": "Es startet im Vollbild. Mit <kbd>Esc</kbd> öffnest du das Menü.",
    "inst.m1": "Entpack den Download und zieh <code>Last Exhibit.app</code> in den Programme-Ordner.",
    "inst.m2": "Rechtsklick auf die App, <b>Öffnen</b>, dann nochmal <b>Öffnen</b>. Ab macOS 15: <b>Systemeinstellungen → Datenschutz &amp; Sicherheit</b> und dort <b>Trotzdem öffnen</b>.",
    "inst.m3": "Wenn macOS meldet, die App sei beschädigt, führ das einmal im Terminal aus:",
    "inst.l1": "Entpack den Download. Lass <code>LastExhibit.x86_64</code> und <code>LastExhibit.pck</code> zusammen.",
    "inst.l2": "Ausführbar machen und starten:",
    "inst.l3": "Wenn du die Datei vorher prüfen willst, vergleich die Prüfsumme mit der oben:",

    "ctrl.title": "Steuerung",
    "ctrl.lede": "Tastatur und Maus. Jede Taste lässt sich auf dem Handy unter Einstellungen → Keybinds neu belegen.",
    "ctrl.move": "Laufen",
    "ctrl.climb": "Klettern, Aufzüge",
    "ctrl.jump": "Springen",
    "ctrl.space": "Leertaste",
    "ctrl.melee": "Nahkampf, 3er-Combo",
    "ctrl.lmb": "Linksklick",
    "ctrl.shoot": "Schießen (mit Waffe)",
    "ctrl.rmb": "Rechtsklick",
    "ctrl.interact": "Interagieren, aufheben",
    "ctrl.phone": "Handy",
    "ctrl.items": "Inventarplatz benutzen",
    "ctrl.menu": "Pausenmenü",

    "req.title": "Was es braucht",
    "req.lede": "Last Exhibit nutzt Godots Kompatibilitäts-Renderer und läuft deshalb auf den meisten Computern der letzten zehn Jahre, auch mit integrierter Grafik.",
    "req.system": "System",
    "req.graphics": "Grafik",
    "req.win": "Windows 10 oder 11, 64-Bit",
    "req.mac": "Ein aktuelles macOS, Intel oder Apple Silicon",
    "req.linux": "Eine aktuelle 64-Bit-Distribution",
    "req.web": "Aktuelles Chrome, Edge, Firefox oder Safari auf dem Desktop",
    "req.saves": "Der Fortschritt wird in drei Slots auf deinem Computer gespeichert. Die Browser-Version speichert im Browser: Wer die Websitedaten löscht, löscht sein Museum.",

    "faq.title": "Fragen an der Kasse",
    "faq.q1": "Ist das wirklich kostenlos?",
    "faq.a1": "Ja. Last Exhibit ist ein Schulprojekt von vier Schülern. Es gibt nichts zu kaufen, weder im Spiel noch außerhalb. Die einzige Währung ist gestohlen.",
    "faq.q2": "Wie lang ist es?",
    "faq.a2": "Das hängt davon ab, wie voll deine Vitrinen werden sollen. Es gibt vier Epochen und vier Bosse, und nach dem Ritter in Erlenbach läuft der Abspann.",
    "faq.q3": "Kann ich mit Controller spielen?",
    "faq.a3": "Noch nicht. Das Spiel ist für Tastatur und Maus gebaut.",
    "faq.q4": "Kann ich auf dem Handy spielen?",
    "faq.a4": "Die Browser-Version lädt auch auf dem Handy, aber zum Spielen brauchst du eine Tastatur. Nimm einen Computer.",
    "faq.q5": "Ist das Spiel auf Deutsch?",
    "faq.a5": "Das Spiel ist auf Englisch. Diese Website gibt es in beiden Sprachen.",
    "faq.q6": "Etwas startet nicht.",
    "faq.a6": "Prüf, ob die <code>.pck</code>-Datei neben dem Programm liegt. Dann frag im <a href=\"https://discord.gg/DU29ufhM8F\" rel=\"noopener\">Discord</a> und sag dazu, welches System du nutzt.",

    "cred.project": "Ein Schulprojekt",
    "cred.programming": "Programmierung",
    "cred.design": "Game Design",
    "cred.art": "Grafikdesign",
    "cred.music": "Musik und Sounddesign",
    "cred.thanks": "Besonderer Dank",
    "cred.you": "Dir, fürs Spielen",
    "cred.fine1": "Pixel-Art, Musik und die Schrift Pixuf stammen aus dem Spiel. Einige Sprites nutzen kostenlose Pakete von CraftPix und GandalfHardcore.",
    "cred.fine2": "Code der Website unter MIT-Lizenz."
  };

  var ATTRS = ["alt", "aria-label", "content", "title"];

  function readStored() {
    try { return localStorage.getItem(STORAGE_KEY); } catch (e) { return null; }
  }
  function store(lang) {
    try { localStorage.setItem(STORAGE_KEY, lang); } catch (e) { /* private mode */ }
  }

  var initial = readStored();
  if (initial !== "en" && initial !== "de") {
    initial = /^de\b/i.test(navigator.language || "") ? "de" : "en";
  }

  var api = {
    lang: initial,

    t: function (key) {
      var table = SCRIPT[api.lang] || SCRIPT.en;
      if (key in table) return table[key];
      if (key in SCRIPT.en) return SCRIPT.en[key];
      return key;
    },

    pick: function (pair) {
      if (pair == null) return "";
      if (typeof pair === "string") return pair;
      return pair[api.lang] != null ? pair[api.lang] : pair.en;
    },

    set: function (lang) {
      if (lang !== "en" && lang !== "de") return;
      api.lang = lang;
      store(lang);
      apply();
      document.dispatchEvent(new CustomEvent("langchange", { detail: { lang: lang } }));
    }
  };

  /* Remember English exactly as authored, the first time an element is seen */
  function original(el, slot, read) {
    var key = "leOrig" + slot;
    if (!(key in el.dataset)) el.dataset[key] = read();
    return el.dataset[key];
  }

  function apply(root) {
    var scope = root || document;
    var de = api.lang === "de";
    document.documentElement.lang = api.lang;

    scope.querySelectorAll("[data-i18n]").forEach(function (el) {
      var en = original(el, "Html", function () { return el.innerHTML; });
      var next = de && DE[el.dataset.i18n] != null ? DE[el.dataset.i18n] : en;
      if (el.innerHTML !== next) el.innerHTML = next;
    });

    ATTRS.forEach(function (attr) {
      var data = "i18n" + attr.replace(/(^|-)([a-z])/g, function (m, d, c) { return c.toUpperCase(); });
      scope.querySelectorAll("[data-i18n-" + attr + "]").forEach(function (el) {
        var en = original(el, attr.replace("-", ""), function () { return el.getAttribute(attr) || ""; });
        var k = el.dataset[data];
        el.setAttribute(attr, de && DE[k] != null ? DE[k] : en);
      });
    });

    document.querySelectorAll("[data-lang]").forEach(function (btn) {
      btn.setAttribute("aria-pressed", String(btn.dataset.lang === api.lang));
    });
  }

  api.apply = apply;

  /* A page can add its own German copy (play.html does) */
  api.extend = function (dict) {
    Object.keys(dict).forEach(function (k) { DE[k] = dict[k]; });
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
