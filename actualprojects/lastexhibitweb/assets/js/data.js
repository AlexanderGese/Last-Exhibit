/* ==========================================================================
   Last Exhibit — game data shown on the site

   Every number here is read out of the Godot project, not invented:
     artifacts   scenes/Epochs/<era>/artifacts/*.tres      (name, value, stack)
     darknet     inventory/items/blackmarket/*.tres + SaveManager._apply_effect
     eras        scenes/Zeitmaschine/zeitmaschinen_ui.gd  (years, unlock costs)
     bosses      scenes/Epochs/<era>/Boss/*.gd             (HP, attacks)
     quotes      dialogues/*.dialogue
     controls    project.godot [input]
   If the game changes, change it here. Strings that need a translation are
   { en, de } pairs; proper names are left as they appear in the game.
   ========================================================================== */

window.LE_DATA = (function () {
  "use strict";

  var ART = "assets/img/artifacts/";

  /* ------------------------------------------------------------------------
     Artifacts — value is in coins; the darknet pays 7% of it in BTC.
     ------------------------------------------------------------------------ */
  var artifacts = [
    // Soviet Union, 1965
    { id: "gasmaske",    era: "soviet", name: "Gasmask",                          value: 250, img: "gasmaske.png" },
    { id: "lada",        era: "soviet", name: "Lada Niva",                        value: 310, img: "lada.png", big: true },
    { id: "laika",       era: "soviet", name: "Laika",                            value: 170, img: "laika.png" },
    { id: "matrjoschka", era: "soviet", name: "Matryoshka",                       value: 110, img: "matjoschka.png" },
    { id: "nowitschok",  era: "soviet", name: "Novichok Poison",                  value: 310, img: "nowitschok.png" },
    { id: "orden",       era: "soviet", name: "Medal of the Great Patriotic War", value: 300, img: "orden-single.png", gift: "Dmitri" },
    { id: "soljanka",    era: "soviet", name: "Solyanka Stew",                    value: 10,  img: "soljanka.png", stack: 3, big: true },
    { id: "sputnik",     era: "soviet", name: "Sputnik Satellite",                value: 420, img: "satellite.png", big: true },

    // Second World War, 1943
    { id: "bild",            era: "ww2", name: "Painting",          value: 110, img: "bild.png" },
    { id: "feldtelefon",     era: "ww2", name: "Field Telephone",   value: 310, img: "feldtelefon.png", stack: 3 },
    { id: "helm",            era: "ww2", name: "Pilot Helmet",      value: 500, img: "pilotenhelm.png", boss: true },
    { id: "muni",            era: "ww2", name: "Ammunition Belt",   value: 40,  img: "munitionsguertel.png", stack: 5 },
    { id: "purple",          era: "ww2", name: "Purple Heart",      value: 500, img: "purpleheart.png", boss: true },
    { id: "reifen",          era: "ww2", name: "Jeep Wheel",        value: 15,  img: "jeepreifen.png", stack: 5 },
    { id: "schreibmaschine", era: "ww2", name: "Typewriter",        value: 150, img: "schreibmaschine.png", stack: 3 },
    { id: "werkzeugkasten",  era: "ww2", name: "Toolbox",           value: 90,  img: "werkzeug-schrank.png", stack: 3 },
    { id: "werkzeug",        era: "ww2", name: "Tools",             value: 60,  img: "werkzeug.png", stack: 3 },

    // Middle Ages, ~1200
    { id: "axt",          era: "medieval", name: "Axe",             value: 90,  img: "axt.png", stack: 5 },
    { id: "bibel",        era: "medieval", name: "Holy Bible",      value: 170, img: "bibel.png" },
    { id: "kelch",        era: "medieval", name: "Golden Chalice",  value: 90,  img: "kelch.png", stack: 3 },
    { id: "ritterhelm",   era: "medieval", name: "Knight's Helmet", value: 500, img: "ritterhelm.png", boss: true },
    { id: "schwert",      era: "medieval", name: "Knight's Sword",  value: 500, img: "schwert.png", boss: true },
    { id: "siegel",       era: "medieval", name: "Signet",          value: 90,  img: "siegel.png", stack: 2 },
    { id: "arschschwert", era: "medieval", name: "Rusty Sword",     value: 150, img: "verrostetes-schwert.png", stack: 3 },
    { id: "wappen",       era: "medieval", name: "Coat of Arms",    value: 165, img: "wappen.png" },
    { id: "wein",         era: "medieval", name: "Wine Bottle",     value: 20,  img: "weinflasche.png", stack: 5 },

    // Japan, 1600
    { id: "bonsai",       era: "japan", name: "Bonsai Tree",        value: 160, img: "bonsai.png", stack: 3 },
    { id: "chochin",      era: "japan", name: "Chōchin Lantern",    value: 110, img: "chochin.png", stack: 10 },
    { id: "essstaebchen", era: "japan", name: "Chopsticks",         value: 130, img: "essensstaebchen.png", stack: 3 },
    { id: "gong",         era: "japan", name: "Gong",               value: 170, img: "gong.png" },
    { id: "kocher",       era: "japan", name: "Quiver with Arrows", value: 250, img: "pfeilkoecher.png" },
    { id: "maske",        era: "japan", name: "Samurai Mask",       value: 500, img: "samurai.png", stack: 3, boss: true },
    { id: "ritualsteine", era: "japan", name: "Ritual Stones",      value: 10,  img: "ritualsteine.png", stack: 5 },
    { id: "strohhut",     era: "japan", name: "Straw Hat",          value: 170, img: "strohhut.png" },
    { id: "trommel",      era: "japan", name: "Drum",               value: 170, img: "trommel.png" }
  ];

  artifacts.forEach(function (a, i) {
    a.src = ART + a.img;
    a.btc = Math.max(1, Math.round(a.value * 0.07));
    a.acc = "LE." + (i + 1 < 10 ? "0" : "") + (i + 1);
  });

  /* ------------------------------------------------------------------------
     Eras. x/y place the pin on the time machine's world map (percent).
     t places the handle on the year bar (0 = present, 100 = deepest).
     Sprites: sheet, frame size, frame count, scale.
     ------------------------------------------------------------------------ */
  var eras = [
    {
      id: "soviet",
      name: { en: "Soviet Union", de: "Sowjetunion" },
      year: "1965",
      t: 10,
      pin: { x: 48.5, y: 27.5 },
      unlock: { en: "Open from the first night", de: "Ab der ersten Nacht offen" },
      place: { en: "A control post and bunker", de: "Ein Kontrollposten mit Bunker" },
      mood: {
        en: "Red emergency light, a Sputnik launcher standing in the dark, and a boss who keeps his distance until you get too close.",
        de: "Rotes Notlicht, eine Sputnik-Startrampe im Dunkeln und ein Boss, der Abstand hält, bis du zu nah kommst."
      },
      boss: { en: "The scientist in the lab coat", de: "Der Wissenschaftler im Laborkittel" },
      hp: 350,
      attacks: {
        en: "Molotov that leaves fire for 5 s · AK47 bursts, 20 per bullet · Grenade, 48 damage · Sprints when you get within reach",
        de: "Molotow, der 5 s brennt · AK47-Salven, 20 pro Kugel · Granate, 48 Schaden · Sprintet, sobald du in Reichweite bist"
      },
      shards: 20,
      npc: "Dmitri",
      quotes: [
        { en: "David? Weird name... People have normal name where I come from.", de: "David? Komischer Name... Wo ich herkomme, haben Leute normale Namen." },
        { en: "I give you my AK47... if you beat me in boxfight!", de: "Ich gebe dir meine AK47... wenn du mich im Boxkampf schlägst!" },
        { en: "AAAH! The alien is back!", de: "AAAH! Der Außerirdische ist zurück!" }
      ],
      sprite: { src: "assets/img/bosses/soviet-shot.png", fw: 128, fh: 128, cols: 2, frames: 4, scale: 1.6, fps: 6 },
      tracks: { level: "soviet-level", boss: "soviet-boss" }
    },
    {
      id: "ww2",
      name: { en: "Second World War", de: "Zweiter Weltkrieg" },
      year: "1943",
      t: 16,
      pin: { x: 13.5, y: 39 },
      unlock: { en: "15 time shards", de: "15 Zeitsplitter" },
      place: { en: "A US air force base in California", de: "Eine US-Luftwaffenbasis in Kalifornien" },
      mood: {
        en: "Barrels, a fence, a jeep, and a commander who is sure you are a German spy. The boss is not a person. It's a P-51.",
        de: "Fässer, ein Zaun, ein Jeep und ein Kommandant, der dich für einen deutschen Spion hält. Der Boss ist kein Mensch. Es ist eine P-51."
      },
      boss: { en: "P-51 Mustang", de: "P-51 Mustang" },
      hp: 400,
      attacks: {
        en: "Strafing runs, five-round bursts · At 75%, 50% and 25% health: a rain of 60 bombs",
        de: "Tiefflüge mit Fünfersalven · Bei 75 %, 50 % und 25 % Leben: ein Regen aus 60 Bomben"
      },
      shards: 30,
      npc: "Johnathan Sinners",
      quotes: [
        { en: "Again a german spy! How the hell do they even get onto the damn property?", de: "Schon wieder ein deutscher Spion! Wie zum Teufel kommen die überhaupt aufs Gelände?" },
        { en: "My name is Johnathan Sinners, I am the chief commander of this air force base!", de: "Mein Name ist Johnathan Sinners, ich bin der Oberbefehlshaber dieser Luftwaffenbasis!" },
        { en: "Pardon? You german Bastard!", de: "Wie bitte? Du deutscher Bastard!" }
      ],
      sprite: { src: "assets/img/bosses/p51.png", fw: 450, fh: 190, cols: 3, frames: 3, scale: 0.62, fps: 18 },
      tracks: { level: "ww2-level", boss: "ww2-boss" }
    },
    {
      id: "japan",
      name: { en: "Feudal Japan", de: "Feudales Japan" },
      year: "1600",
      t: 46,
      pin: { x: 60, y: 37 },
      unlock: { en: "25 time shards", de: "25 Zeitsplitter" },
      place: { en: "Narai-juku, a post town", de: "Narai-juku, eine Poststadt" },
      mood: {
        en: "A quiet village, a woman who has run out of ways to calm the samurai down, and more time shards than anywhere else.",
        de: "Ein stilles Dorf, eine Frau, der die Ideen ausgehen, wie sie die Samurai beruhigen soll, und mehr Zeitsplitter als irgendwo sonst."
      },
      boss: { en: "The samurai", de: "Der Samurai" },
      hp: 800,
      attacks: {
        en: "Two sword attacks, 30 damage · A dash-stab across the arena, 40 damage",
        de: "Zwei Schwertangriffe, 30 Schaden · Ein Sprungstich quer durch die Arena, 40 Schaden"
      },
      shards: 45,
      npc: "Hana Nakamura",
      quotes: [
        { en: "Hana means flower and nakamura means something like “village in the middle”.", de: "Hana heißt Blume und Nakamura so etwas wie „Dorf in der Mitte“." },
        { en: "They look so aggressive. I can't calm them down with tea or anything!", de: "Die sehen so aggressiv aus. Ich kann sie nicht mal mit Tee beruhigen!" },
        { en: "I hope you have a great time here in Narai-juku.", de: "Ich hoffe, du hast eine schöne Zeit hier in Narai-juku." }
      ],
      sprite: { src: "assets/img/bosses/samurai-idle.png", fw: 128, fh: 128, cols: 6, frames: 6, scale: 1.8, fps: 8 },
      tracks: { level: "japan-level", boss: "japan-boss" }
    },
    {
      id: "medieval",
      name: { en: "Middle Ages", de: "Mittelalter" },
      year: "~1200",
      t: 86,
      pin: { x: 36, y: 31 },
      unlock: { en: "40 time shards", de: "40 Zeitsplitter" },
      place: { en: "Erlenbach: woods, a mineshaft, a castle", de: "Erlenbach: Wald, Minenschacht, Burg" },
      mood: {
        en: "The deepest night the machine reaches. A knight guards the castle, and whatever happens after him is the end of the game.",
        de: "Die tiefste Nacht, die die Maschine erreicht. Ein Ritter bewacht die Burg, und was nach ihm kommt, ist das Ende des Spiels."
      },
      boss: { en: "The knight of Erlenbach", de: "Der Ritter von Erlenbach" },
      hp: 1200,
      attacks: {
        en: "Two sword attacks, 30 damage · A dash-stab, 40 damage · 1200 health, the most in the game",
        de: "Zwei Schwertangriffe, 30 Schaden · Ein Sprungstich, 40 Schaden · 1200 Leben, mehr als alles andere im Spiel"
      },
      shards: 20,
      npc: "The Dark Knight",
      quotes: [
        { en: "Hello fellow Christian! Why are you wandering around here in the woods?", de: "Sei gegrüßt, Glaubensbruder! Warum irrst du hier im Wald umher?" },
        { en: "They go through the village and steal every precious object they can find.", de: "Sie ziehen durchs Dorf und stehlen alles Wertvolle, das sie finden." },
        { en: "I thought that when I saw you. Not better than every civilian.", de: "Das dachte ich mir, als ich dich sah. Nicht besser als jeder andere Zivilist." }
      ],
      sprite: { src: "assets/img/bosses/knight-idle.png", fw: 128, fh: 128, cols: 4, frames: 4, scale: 1.8, fps: 6 },
      tracks: { level: "medieval-level", boss: "medieval-boss" }
    },
    {
      id: "inca",
      locked: true,
      name: { en: "Inca Empire", de: "Inkareich" },
      year: "1530",
      t: 54,
      pin: { x: 21.5, y: 55 },
      unlock: { en: "The machine won't go there", de: "Die Maschine fährt nicht dorthin" },
      place: { en: "Unknown", de: "Unbekannt" },
      mood: {
        en: "There is a pin for 1530 on the machine's map, and music already written for it. Pull the handle and nothing happens. Not yet.",
        de: "Auf der Karte der Maschine steckt eine Nadel für 1530, und die Musik dafür ist schon geschrieben. Zieh am Hebel, und nichts passiert. Noch nicht."
      },
      boss: { en: "—", de: "—" },
      hp: null,
      attacks: { en: "—", de: "—" },
      shards: null,
      npc: null,
      quotes: [],
      sprite: null,
      tracks: { level: "inca-level", boss: "inca-boss" }
    }
  ];

  /* ------------------------------------------------------------------------
     The darknet — the Tor app on David's phone. Prices in BTC.
     ------------------------------------------------------------------------ */
  var darknet = [
    { name: "Street Stim",         btc: 50,   img: "stim_health.png", effect: { en: "Heals 60 HP on the spot.", de: "Heilt sofort 60 LP." } },
    { name: "Painkillers",         btc: 80,   img: "painkillers.png", effect: { en: "Regenerates 2 HP a second for 20 seconds.", de: "Regeneriert 20 Sekunden lang 2 LP pro Sekunde." } },
    { name: "Molotov",             btc: 100,  img: "molotow.png",     effect: { en: "Throw it. The floor stays on fire.", de: "Werfen. Der Boden brennt weiter." } },
    { name: "Adrenaline Shot",     btc: 120,  img: "stim.png",        effect: { en: "Move 1.6× faster for 10 seconds.", de: "10 Sekunden lang 1,6× schneller." } },
    { name: "Temporal Anchor",     btc: 150,  img: "anchor.png",      effect: { en: "Adds 30 seconds before the past lets go of you.", de: "30 Sekunden mehr, bevor dich die Vergangenheit loslässt." } },
    { name: "EMP Charge",          btc: 200,  img: "emp.png",         effect: { en: "Every enemy freezes for 3 seconds.", de: "Alle Gegner erstarren für 3 Sekunden." } },
    { name: "Time Dilation Serum", btc: 250,  img: "potion.png",      effect: { en: "The whole world runs at 0.4× speed for 5 seconds.", de: "Die ganze Welt läuft 5 Sekunden lang mit 0,4× Tempo." } },
    { name: "Second Wind",         btc: 600,  img: "totem.png",       effect: { en: "The next time you would die, you don't. Full health and 2 seconds untouchable.", de: "Wenn du das nächste Mal sterben würdest, stirbst du nicht. Volle Gesundheit und 2 Sekunden unverwundbar." } },
    { name: "Overclock Chip",      btc: 2500, img: "chip.png",        effect: { en: "Permanently adds one hit to your melee combo.", de: "Dein Nahkampf-Combo bekommt dauerhaft einen Schlag mehr." } }
  ];
  darknet.forEach(function (d) { d.src = "assets/img/kammer/" + d.img; });

  /* ------------------------------------------------------------------------
     Soundtrack — every track in assets/music, in the order you hear them.
     ------------------------------------------------------------------------ */
  var tracks = [
    { id: "trailer",        title: { en: "Main Menu", de: "Hauptmenü" },          where: { en: "Title screen", de: "Titelbildschirm" },            dur: 218 },
    { id: "museum-night",   title: { en: "Museum at Night", de: "Museum bei Nacht" }, where: { en: "22:00–06:00", de: "22:00–06:00" },            dur: 240 },
    { id: "soviet-level",   title: { en: "Soviet Union", de: "Sowjetunion" },      where: { en: "1965 · Level", de: "1965 · Level" },              dur: 480 },
    { id: "soviet-boss",    title: { en: "Soviet Union — Boss", de: "Sowjetunion — Boss" }, where: { en: "1965 · Boss", de: "1965 · Boss" },     dur: 232 },
    { id: "ww2-level",      title: { en: "Air Base", de: "Luftwaffenbasis" },      where: { en: "1943 · Level", de: "1943 · Level" },              dur: 289 },
    { id: "ww2-boss",       title: { en: "P-51", de: "P-51" },                     where: { en: "1943 · Boss", de: "1943 · Boss" },                dur: 165 },
    { id: "japan-level",    title: { en: "Narai-juku", de: "Narai-juku" },         where: { en: "1600 · Level", de: "1600 · Level" },              dur: 389 },
    { id: "japan-boss",     title: { en: "The Samurai", de: "Der Samurai" },       where: { en: "1600 · Boss", de: "1600 · Boss" },                dur: 277 },
    { id: "medieval-level", title: { en: "Erlenbach", de: "Erlenbach" },           where: { en: "~1200 · Level", de: "~1200 · Level" },            dur: 266 },
    { id: "medieval-boss",  title: { en: "The Knight", de: "Der Ritter" },         where: { en: "~1200 · Boss", de: "~1200 · Boss" },              dur: 234 },
    { id: "inca-level",     title: { en: "Inca Empire", de: "Inkareich" },         where: { en: "1530 · not in the game yet", de: "1530 · noch nicht im Spiel" }, dur: 349 },
    { id: "inca-boss",      title: { en: "Inca Empire — Boss", de: "Inkareich — Boss" }, where: { en: "1530 · not in the game yet", de: "1530 · noch nicht im Spiel" }, dur: 279 },
    { id: "kammer",         title: { en: "The Darknet", de: "Das Darknet" },       where: { en: "Written for the black market", de: "Für den Schwarzmarkt geschrieben" }, dur: 408 },
    { id: "museum-day",     title: { en: "Museum by Day", de: "Museum bei Tag" },  where: { en: "06:00–22:00", de: "06:00–22:00" },               dur: 146 },
    { id: "final",          title: { en: "Credits", de: "Abspann" },               where: { en: "After Erlenbach", de: "Nach Erlenbach" },         dur: 212 }
  ];
  tracks.forEach(function (t) { t.src = "assets/audio/" + t.id + ".mp3"; });


  return {
    artifacts: artifacts,
    eras: eras,
    darknet: darknet,
    tracks: tracks
  };
})();
