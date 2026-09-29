/* ==========================================================================
   Last Exhibit — Daten aus dem Spiel

   Alles hier steht so im Godot-Projekt:
     Darknet   inventory/items/blackmarket/*.tres und SaveManager._apply_effect
     Musik     assets/music/
   Wenn sich das Spiel ändert, hier nachziehen. Texte, die übersetzt werden,
   sind { de, en }-Paare; Eigennamen bleiben wie im Spiel.
   ========================================================================== */

window.LE_DATA = (function () {
  "use strict";

  /* Das Darknet, also die Tor-App auf Davids Handy. Preise in BTC. */
  var darknet = [
    { name: "Street Stim",         btc: 50,   img: "stim_health.png", effect: { de: "Heilt 60 LP.", en: "Heals 60 HP." } },
    { name: "Painkillers",         btc: 80,   img: "painkillers.png", effect: { de: "20 Sekunden lang 2 LP pro Sekunde.", en: "2 HP per second for 20 seconds." } },
    { name: "Molotov",             btc: 100,  img: "molotow.png",     effect: { de: "Werfen, dann brennt der Boden.", en: "Throw it and the floor catches fire." } },
    { name: "Adrenaline Shot",     btc: 120,  img: "stim.png",        effect: { de: "10 Sekunden lang 1,6x so schnell.", en: "1.6x speed for 10 seconds." } },
    { name: "Temporal Anchor",     btc: 150,  img: "anchor.png",      effect: { de: "+30 Sekunden auf dem Level-Timer.", en: "+30 seconds on the level timer." } },
    { name: "EMP Charge",          btc: 200,  img: "emp.png",         effect: { de: "Friert alle Gegner 3 Sekunden ein.", en: "Freezes all enemies for 3 seconds." } },
    { name: "Time Dilation Serum", btc: 250,  img: "potion.png",      effect: { de: "Spiel läuft 5 Sekunden lang auf 0,4x.", en: "Slows the game to 0.4x for 5 seconds." } },
    { name: "Second Wind",         btc: 600,  img: "totem.png",       effect: { de: "Belebt dich einmal mit vollen LP wieder.", en: "Revives you once with full HP." } },
    { name: "Overclock Chip",      btc: 2500, img: "chip.png",        effect: { de: "Ein Schlag mehr in deiner Combo, dauerhaft.", en: "One more hit in your combo, for good." } }
  ];
  darknet.forEach(function (d) { d.src = "assets/img/kammer/" + d.img; });

  /* Musik auf der Seite: nur das Titelthema aus dem Hauptmenü. */
  var tracks = [
    { id: "trailer", title: { de: "Hauptmenü", en: "Main menu" }, dur: 218, src: "assets/audio/trailer.mp3" }
  ];

  return {
    darknet: darknet,
    tracks: tracks
  };
})();
