# Last Exhibit
### Game Design Document v0.6

> *Ein 2D Side-Scroller Metroidvania mit Idle/Clicker-Progression. Du bist Geschichtsstudent, Nachtwächter und unfreiwilliger Zeitdieb. Jede Nacht plünderst du die Geschichte. Jeden Tag öffnet das Museum.*

---

## Inhaltsverzeichnis

1. [Übersicht](#1-übersicht)
2. [Team](#2-team)
3. [Technische Basis](#3-technische-basis)
4. [Ton und Atmosphäre](#4-ton-und-atmosphäre)
5. [Protagonist — David A.](#5-protagonist--david-a)
6. [Der Wissenschaftler — Herr K.](#6-der-wissenschaftler--herr-k)
7. [Narrative Struktur](#7-narrative-struktur)
8. [UI und Screens](#8-ui-und-screens)
9. [Der Kernloop](#9-der-kernloop)
10. [Die zwei Dimensionen](#10-die-zwei-dimensionen--zeittiefe--expeditionsradius)
11. [Währungen](#11-währungen)
12. [Die Zeitmaschine und der Keller](#12-die-zeitmaschine-und-der-keller)
13. [Expedition und Kampf](#13-expedition-und-kampf)
14. [Das Museum](#14-das-museum)
15. [Museum-Events](#15-museum-events)
16. [Personal](#16-personal)
17. [Die Kammer — Schwarzmarkt](#17-die-kammer--schwarzmarkt)
18. [Epochen](#18-epochen)
19. [Dialoge und Narrative](#19-dialoge-und-narrative)
20. [Audio](#20-audio)
21. [Visuelles Design](#21-visuelles-design)
22. [Speichersystem](#22-speichersystem)
23. [Steam Achievements](#23-steam-achievements)
24. [Ende und Abschluss](#24-ende-und-abschluss)
25. [Geschäftsmodell](#25-geschäftsmodell)
26. [Offene Punkte](#26-offene-punkte)

---

## 1. Übersicht

| Feld | Wert |
|------|------|
| **Titel** | Last Exhibit |
| **Genre** | 2D Side-Scroller Metroidvania + Idle/Clicker |
| **Engine** | Godot 4.x |
| **Plattformen** | PC (Steam), Mobile (iOS/Android) |
| **Multiplayer** | Nein — rein singleplayer |
| **Replayability** | Ein Durchlauf — kein New Game+ |
| **Speichern** | Automatisch nach jeder Nacht — mehrere Slots |
| **Ziel-Release** | 3 Monate ab Projektstart |
| **Preis PC** | 14,99 € |
| **Preis Mobile** | Einmalkauf + optionale DLCs |
| **Sprache** | Englisch |

**Elevator Pitch:**
David A. kauft ein verlassenes Museum am Stadtrand. In der dritten Woche findet er hinter einer falschen Kellerwand eine Zeitmaschine. Teilweise funktionsfähig. Eine Notiz hängt dran: *„Bitte nicht benutzen."* David liest sie. Zögert kurz. Benutzt sie trotzdem.

Jede Nacht reist er in eine andere Epoche. Er kämpft, stiehlt, überlebt. Nach einigen Epochen findet er in Tagebucheinträgen Hinweise auf einen Ort — die Kammer. Immer am selben Ort. Zu groß für das Gebäude drum herum. Fühlt sich an als wäre sie außerhalb der Zeit. Fünf Händler. Und in einer Ecke: ein Mann im abgewetzten Mantel, der nur sitzt und beobachtet. Herr K.

David weiß zunächst nicht wer er ist. Gegen Ende versteht er es.

---

## 2. Team

| Name | Rolle |
|------|-------|
| **Alexander Gese** | TBD |
| **Paul Korn** | TBD |
| **Fabian Wolf** | TBD |
| **Johannes Schneider** | TBD |

*Rollenverteilung intern festlegen und hier ergänzen.*

---

## 3. Technische Basis

| Feld | Wert |
|------|------|
| **Engine** | Godot 4.x |
| **Sprache** | GDScript |
| **Perspektive** | 2D Side-Scroller |
| **Grafik** | Pixel Art — Stil TBD |
| **Spielsprache** | Englisch |
| **Controller** | Ja — PC Controller-Support |
| **Schwierigkeitsgrad** | Fest — keine Einstellung |
| **Achievements** | Ja — Steam Achievements (4 Kategorien) |
| **Speicherslots** | Mehrere Slots |
| **Cloud Save** | TBD |

### Mobile
- Touch-Controls für Bewegung und Kampf
- UI vergrößert für kleine Bildschirme
- Identisches Spielerlebnis — kein Pay-to-Win
- Einmalkauf + optionale DLCs

---

## 4. Ton und Atmosphäre

Alle vier Stimmungen gleichzeitig — keine dominiert.

**Düster und unheimlich:**
Die Kammer ist zu groß für das Gebäude. Herr K. sitzt nur in einer Ecke und beobachtet. Das Kind redet nie. Die letzten Tagebucheinträge sind kaum lesbar. Am Ende erklärt sich Herr K. — und verschwindet danach einfach.

**Humorvoll-absurd:**
Viktor beschwert sich schriftlich über historisch inkorrekte Exponate. Osman findet Münzen hinter Vitrinen. Bruno macht immer Tee. Die Kantine hat niemand gebaut.

**Melancholisch-poetisch:**
David stiehlt von Zivilisationen die nicht mehr existieren. Die Tagebucheinträge gehören einem toten Mann. Das Museum ist zu klein für die Geschichte die es beherbergt. Jeden Morgen öffnet es trotzdem.

**Referenzen:**
- Hollow Knight — Erkundung, Einsamkeit, Welt größer als sie sein sollte
- Franz Kafka — Bürokratie als Horrorgenre
- Gormenghast — Institutionen die ein Eigenleben führen
- Night in the Woods — kleiner Protagonist, große Melancholie

---

## 5. Protagonist — David A.

| Feld | Wert |
|------|------|
| **Name** | David A. — Nachname nicht genannt |
| **Alter** | Anfang-Mitte 20 |
| **Beruf** | Geschichtsstudent — Studium pausiert wegen Museum |
| **Soziales Umfeld** | Buchstäblich allein — niemand vermisst ihn |
| **Grundstimmung** | Beides — neugierig-optimistisch und melancholisch |

**Backstory:**
David kauft das verlassene Museum. Es gehörte einem Wissenschaftler der vor wenigen Monaten gestorben ist. In der dritten Woche findet er hinter einer falschen Kellerwand die Zeitmaschine. Teilweise funktionsfähig. Er liest die Notiz. Zögert kurz. Benutzt sie trotzdem. Niemand weiß davon. Es gibt niemanden dem er es erzählen könnte.

**Fähigkeitsprogression — durch Wiederholung:**

| Fähigkeit | Wächst durch |
|-----------|--------------|
| Sprintausdauer | Oft bis Erschöpfung sprinten und überleben |
| Tragekapazität | Schwere Lasten erfolgreich zurückbringen |
| Fallhöhe | Überleben was eigentlich zu hoch war |
| Kampfreflexe | Kurz vor Treffer ausweichen |
| Stille Bewegung | Gegner unentdeckt passieren |
| Werkzeugkunde | Ein Werkzeug oft benutzen |
| Schnellwechsel | Genug Kämpfe überstehen |
| Improvisieren | Sehr viele Nächte überstehen |

---

## 6. Der Wissenschaftler — Herr K.

| Feld | Wert |
|------|------|
| **Name** | Namenlos — nur "der Wissenschaftler" / "Herr K." |
| **Status** | Tot — Unfall mit der Zeitmaschine, vor wenigen Monaten |
| **Ziel** | Den Ursprung der Zeit verstehen |
| **Erscheinung** | Als Herr K. in der Kammer |

**Wer er ist:**
Der Wissenschaftler hat das Museum gebaut, die Zeitmaschine konstruiert und ist bei einem Unfall mit ihr gestorben. Was genau er herausgefunden hat steht in seinen Tagebüchern. Er ist als Herr K. zurückgekehrt — wie und warum wird nie vollständig erklärt, bis zum Ende.

**Als Herr K. in der Kammer:**
Er sitzt immer in derselben Ecke. Beobachtet. Sagt nichts — bis zum Ende. Die fünf Händler in der Kammer sind unabhängig von ihm. Er betreibt die Kammer nicht — er ist einfach da.

**Die Enthüllung:**
Gegen Ende des Spiels, wenn David den letzten Tagebucheintrag findet und versteht was der Wissenschaftler entdeckt hat, erkennt David von selbst wer Herr K. ist. Erst dann erklärt sich Herr K. — kurz, ruhig, ohne viele Worte. Danach verschwindet er einfach. Kein Drama. Keine große Abschiedsszene.

**Die Verbindung wird nie explizit gesagt:**
Kleinere Details streuen sich durch das Spiel — eine Geste die zu einer Skizze im Keller passt, eine Reaktion auf ein bestimmtes Artefakt, ein Detail in seinem Mantel. Wer aufmerksam liest merkt es früher. Wer nicht — versteht es am Ende.

---

## 7. Narrative Struktur

### Drei Schichten

| Schicht | Inhalt |
|---------|--------|
| **Oberfläche** | Museum wächst, Nächte vergehen, David lernt kämpfen |
| **Mitte** | Wer war der Wissenschaftler? Was hat er gesucht? Was hat er gefunden? |
| **Tief** | Wer ist Herr K.? Was steht im letzten Eintrag? Was wählt David? |

### Schwarzmarkt als narrativer Meilenstein

Nach 2–3 Epochen führen Tagebucheinträge David zur Kammer. Das ist kein Gameplay-Gate sondern ein narrativer Moment — David folgt den Hinweisen des Wissenschaftlers und findet den Ort den dieser offenbar kannte. Herr K. sitzt bereits da.

### Tagebucheinträge des Wissenschaftlers

| Ort | Inhalt | Ton |
|-----|--------|-----|
| Keller (Notizen + Skizzen) | Frühe Einträge — Bau der Maschine, erste Tests | Enthusiastisch, wissenschaftlich |
| Verstreut in Epochen | Mittlere Einträge — Entdeckungen, Zweifel | Nachdenklich, zunehmend schwerer |
| Tiefste Epochen | Späte Einträge — die eigentliche Wahrheit | Fragmentiert, persönlich |

### Das Ende

David findet den letzten Eintrag. Er versteht was der Wissenschaftler wusste — und warum die Notiz sagte *„Bitte nicht benutzen."* Er erkennt selbst wer Herr K. ist. Herr K. erklärt sich. Dann verschwindet er einfach.

**Endwahl:**

| Wahl | Ende |
|------|------|
| Maschine zerstören | Credits — Museum bleibt, Herr K. weg, Kammer leer |
| Maschine behalten | Credits — Museum bleibt, Kammer offen, neue Notiz im Keller |

*Was in der letzten Notiz steht: TBD*

---

## 8. UI und Screens

### Hauptmenü
- Titel + Optionen
- Intro-Sequenz: David kauft das Museum
- Spielstand auswählen (mehrere Slots)
- Optionen: Audio, Grafik, Steuerung

### HUD während Expedition
- Klein und minimalistisch
- Lebensbalken — oben links
- Zeitlimit-Indikator — oben rechts (Tageszeit, kein Countdown-Zahlenwert)
- Aktive Werkzeuge — unten

### Inventar-Screen
- Jederzeit öffenbar (auch in Epochen)
- Klein/Mittel: im Inventar
- Groß: physisch getragen — verlangsamt David

### Epochen-Auswahlscreen
- Separater Screen an der Zeitmaschine im Keller
- Freigeschaltete und gesperrte Epochen sichtbar
- Kosten für nächste Freischaltung angezeigt

### Pausemenü
- Jederzeit aufrufbar
- Optionen, Steuerung, Beenden

### Journal
- Nur im Museum zugänglich
- Alle gefundenen Tagebucheinträge chronologisch
- Leere Seiten für noch nicht gefundene Einträge — Anzahl bekannt

### Upgrade-Menü
- Nur an der Zeitmaschine im Keller
- Zeittiefe-Tab / Radius-Tab
- Wartungsstatus sichtbar

---

## 9. Der Kernloop

```
SPIELSTART → Intro: David kauft das Museum → Museumsname wählen
    │
    ▼
Keller entdecken → Zeitmaschine hinter falscher Wand
    │
═══════════════════════════════════
NACHT
═══════════════════════════════════
    │
    ▼
Keller → Epochen-Auswahlscreen → Zeittiefe + Radius einstellen
    │
    ▼
Expedition
    ├── Kämpfen, Erkunden, Sammeln
    ├── Artefakte (leuchten) aufheben
    ├── Neutrale NPCs fragen
    ├── Versteckte Räume finden
    ├── Tagebucheintrag finden
    └── Boss besiegen
    │
    ▼
Nach 2–3 Epochen: Tagebuch führt zur Kammer
    │
    ▼
Zeitlimit läuft ab → rechtzeitig zurück oder 1 Tag verloren
Tod → alle Artefakte dieser Nacht verloren
    │
═══════════════════════════════════
TAGPHASE — gespeichert
═══════════════════════════════════
    │
    ├── Artefakte ausstellen / lagern / verkaufen
    ├── Journal lesen (nur hier)
    ├── Passives Einkommen
    ├── Zufalls-Events
    ├── Museum upgraden
    ├── Keller: Maschine upgraden, Notizen untersuchen, Türen öffnen
    └── Personal verwalten
    │
    ▼
NEUE NACHT
```

---

## 10. Die zwei Dimensionen — Zeittiefe & Expeditionsradius

### Zeittiefe — Epochen der Reihe nach freischalten

| Stufe | Epoche | Freischaltung |
|-------|--------|---------------|
| 1 | 1800er–1900er | Von Anfang an |
| 2 | Mittelalter–Renaissance | Time Shards |
| 3 | Antike | Time Shards |
| 4 | Alte Zivilisationen | Time Shards |
| 5 | Prähistorie | Time Shards — sehr teuer |
| 6 | ??? | Nur über Kammer |

### Expeditionsradius

| Größe | Karte | Risiko | Ertrag |
|-------|-------|--------|--------|
| Klein | Nah | Niedrig | Wenig |
| Mittel | Normal | Moderat | Gut |
| Groß | Riesig | Hoch | Enorm |

### Instabilitätswert

| Stufe | Effekt |
|-------|--------|
| Niedrig | Normal |
| Mittel | Gegner schneller, Anker flackert |
| Hoch | Karte verzerrt, Abkürzungen weg |
| Kritisch | Zeitriss — Sonderboss |
| Überlastung | Maschine kaputt — Ruhenacht erzwungen |

---

## 11. Währungen

### Zeittiefe-Währungen

| Währung | Quelle | Verwendung |
|---------|--------|------------|
| **Time Shards** | Boss-Drops, seltene Gegner | Zeittiefe-Upgrades + Epochen |
| **Chronostaub** | Tiefe Epochen | Fortgeschrittene Upgrades |
| **Paradoxsplitter** | Verbotene Aktionen | Mächtigste Upgrades |
| **Ankerenergie** | Passiv im Museum | Stabilisiert Rückweg |

### Expeditionsradius-Währungen

| Währung | Quelle | Verwendung |
|---------|--------|------------|
| **Wegmarken** | Beim Erkunden | Radius-Upgrades |
| **Kartenfragmente** | Kisten, Gegner | Kartenaufbau |
| **Ausdauerkristalle** | Physische Ressource | Ausdauer-Upgrades |
| **Bergungspunkte** | Schwere Rückkehr | Kapazitäts-Upgrades |

### Museum-Währungen

| Währung | Quelle | Verwendung |
|---------|--------|------------|
| **Eintrittsgeld** | Besucher täglich | Museum-Upgrades |
| **Spendengelder** | Reiche Besucher + Events | Große Erweiterungen |
| **Forschungsbudget** | Dokumentation, Schulen | Wissens-Upgrades |
| **Ruhmpunkte** | Nicht ausgeben | Besucherzahl + Events |
| **Schwarzmarktmünzen** | Verbotene Artefakte, Epochen | Kammer-Währung |
| **Betriebskosten** | Negativ — steigt mit Größe | Muss gedeckt sein |

---

## 12. Die Zeitmaschine und der Keller

### Die Maschine
Hinter falscher Wand. Als Heizungsanlage getarnt. Gebaut vom Wissenschaftler. Teilweise funktionsfähig bei Entdeckung.

### Der Keller
Eigene erkundbare Räume. Verschlossene Türen mit Schlüsseln aus Epochen.

**Inhalte:**
- Zeitmaschine (Upgrade-Menü nur hier)
- Notizen und Skizzen des Wissenschaftlers an Wänden
- Frühe Tagebucheinträge
- Verschlossene Türen — Inhalt TBD

### Zeittiefe-Upgrades

| Upgrade | Effekt | Kosten |
|---------|--------|--------|
| Zeitreichweite Stufe 1–6 | Epochen freischalten | Time Shards |
| Temporale Dämpfung | Paradoxgefahr sinkt | Chronostaub |
| Ankervertiefung | Stabilerer Ankerpunkt | Ankerenergie |
| Zeitpuffer | Längerer Aufenthalt | Time Shards |
| Notanker | Sofortige Rückkehr — langer Cooldown | Paradoxsplitter |
| Doppelschicht | Zwei Zeitebenen pro Nacht | Alles |
| Chronoschutz | Artefakte überleben Transport | Chronostaub |
| Erinnerungsverankerung | Weniger Verlust bei Tod | Ankerenergie |

### Expeditionsradius-Upgrades

| Upgrade | Effekt | Kosten |
|---------|--------|--------|
| Reichweite Stufe 1–6 | Größere Karte | Wegmarken |
| Gepäckkapazität | Mehr tragen | Bergungspunkte |
| Ausdauerreserve | Längere Nächte | Ausdauerkristalle |
| Kartographiemodul | Automatisches Kartieren | Kartenfragmente |
| Schnellrouten | Erkundete Wege kürzer | Wegmarken |
| Schleppsystem | Große Artefakte bremsen weniger | Bergungspunkte |
| Vorposten | Temporäre Rückzugspunkte | Ausdauerkristalle |
| Notschlitten | Automatischer Rücktransport | Bergungspunkte |

---

## 13. Expedition und Kampf

### Tutorial
Wie Hollow Knight — interaktiv, kein separater Screen. Erste Epoche ist organisches Kampf-Tutorial.

### Kampfdesign
- Mittel schwer — Hollow Knight Style
- Lebensbalken mit Regeneration
- Parieren und Ausweichen als Kernmechaniken
- Kein Grinding — Skill über Stats
- Fester Schwierigkeitsgrad

### Gefahren
- Normale Gegner (respawnen nach X Nächten)
- Hauptboss + optionaler Geheimboss pro Epoche — nur einmal besiegbar
- Fallen, Umgebungsgefahren
- Neutrale NPCs geben Hinweise — greifen nicht an
- Wasser bremst, schadet nicht
- Tageszeit ändert sich — Wetter fix pro Epoche

### Navigation
- Keine Karte — aus dem Gedächtnis
- Kein Schnellreise — alles zu Fuß
- Kartographiemodul-Upgrade erstellt externe Karte (im Pausemenü)

### Artefakte

| Kategorie | Transport | Ruhm |
|-----------|-----------|------|
| Klein | Inventar | Wenig |
| Mittel | Inventar | Solide |
| Groß | Physisch tragen | Enorm |
| Lebendig | Inventar | Hoch |
| Verboten | Inventar | Keiner im Museum |
| Fragmentiert | Inventar | Sets = Bonus |

Artefakte leuchten / glow wenn sammelbar.

### Tod
Alle Artefakte dieser Nacht verloren. Erfahrungswissen bleibt. Maschine nimmt Schaden. Bruno macht Tee.

### Boss-Typen

| Typ | Mechanik |
|-----|---------|
| Wächtertyp | Vorhersehbar — Geduld |
| Jägertyp | Verfolgt durch Karte |
| Ritualtyp | Umgebung zuerst deaktivieren |
| Maschinentyp | Schwachstellen durch Erkundung |
| Menschentyp | Passt sich Kampfstil an |

---

## 14. Das Museum

**Standort:** Stadtrand einer kleinen unbekannten Stadt
**Setting:** Modern — heute
**Gegenwartsebene:** Museum + Keller
**Name:** Vom Spieler wählbar

### Kapazitäts-Upgrades

| Upgrade | Effekt | Kosten |
|---------|--------|--------|
| Neuer Ausstellungsraum | Grunderweiterung | Eintrittsgeld |
| Themenflügel | Epochen-Synergien | Eintrittsgeld + Ruhm |
| Lagerraum | Artefakte verwahren | Eintrittsgeld |
| Außendepot | Massiver Lagerraum | Spendengelder |
| Sonderausstellungsraum | Temporäre Events | Spendengelder |
| Dachanbau | Neuer Flügel — mehrere Nächte | Alles |

### Prestige-Upgrades

| Upgrade | Effekt | Kosten |
|---------|--------|--------|
| Standardvitrine | Basisschutz | — |
| Beleuchtete Vitrine | Ruhm +30% | Eintrittsgeld |
| Klimatisierte Vitrine | Schützt organische Exponate | Forschungsbudget |
| Interaktive Station | Massiver Ruhm | Forschungsbudget |
| Audioguide | Ruhm pauschal | Eintrittsgeld |
| Informationstafeln | Ruhm + Forschungsbudget | Eintrittsgeld |

### Betriebs-Upgrades

| Upgrade | Effekt | Kosten |
|---------|--------|--------|
| Museumscafé | Besucher bleiben länger | Eintrittsgeld |
| Museumsshop | Passives Extra-Einkommen | Eintrittsgeld |
| Sicherheitssystem | Schutz vor Einbruch | Eintrittsgeld |
| Feuerschutzsystem | Schutz vor Brand | Eintrittsgeld |
| Klimaanlage | Kein Wertverlust | Betriebskosten dauerhaft |
| Wartungsvertrag | Betriebskosten senken | Einmalig Spendengelder |
| Buchungssystem | Schulklassen automatisch | Eintrittsgeld |
| PR-Kampagne | Temporärer Ruhm-Boost | Spendengelder |

### Artefakt-Synergien

| Kombination | Effekt |
|-------------|--------|
| 3 Exponate aus derselben Epoche | Ruhm +50% |
| Komplettes Set einer Epoche | Forschungsbudget +20% dauerhaft |
| Verbotenes + normales Exponat | Ruhm + Risiko steigen |
| Lebendiges + Fragmentartefakt | Forschungsbudget explodiert |

---

## 15. Museum-Events

Zufällig — skaliert mit Ruhmpunkten. Positiv und negativ möglich.

### Positiv

| Event | Effekt |
|-------|--------|
| Journalist | Ruhm-Boost mehrere Tage |
| Reicher Spender | Große Spendengelder |
| Schulklasse | Forschungsbudget-Boost |
| Kunstexperte | Ruhm-Bonus auf Artefakte |
| Lokale Zeitung | Mittlerer Ruhm-Boost |

### Negativ

| Event | Effekt | Schutz |
|-------|--------|--------|
| Einbruch | Artefakt gestohlen | Sicherheitssystem |
| Brand | Raum beschädigt, Artefakt zerstörbar | Feuerschutzsystem |
| Schlechte Kritik | Ruhm sinkt temporär | — |
| Heizungsausfall | Betriebskosten steigen kurz | Wartungsvertrag |
| Vitrine beschädigt | Artefakt nicht ausstellbar | — |

---

## 16. Personal

Erst einstellen wenn Einnahmen die Kosten dauerhaft decken. Kündigen wenn Gehalt nicht gezahlt.

| Name | Rolle | Effekt | Persönlichkeit |
|------|-------|--------|----------------|
| **Marta** | Kassiererin | Findet Spendengelder in Jackentaschen | Kommentiert jedes Exponat |
| **Osman** | Reinigung | Senkt Betriebskosten, findet Münzen | Schweigend, gründlich |
| **Viktor** | Audioguide | Erhöht Ruhm | Beschwert sich schriftlich |
| **Lena** | Restauratorin | Repariert Fragmente passiv | Stellt Fragen über Herkunft |
| **PR-Managerin** | Öffentlichkeit | Spendengelder + Events | Weiß nichts. Will nichts wissen. |
| **Dr. Amara** | Zeitforscherin | Epochen tiefer analysieren | Weiß zu viel |
| **Bruno** | Wachkollege | Deckt David ab | Merkt nichts. Macht Tee. |

---

## 17. Die Kammer — Schwarzmarkt

### Freischaltung

**Wann:** Nach 2–3 Epochen
**Wie:** Tagebucheinträge des Wissenschaftlers führen David zu einem bestimmten Ort — einem Keller unter einem Parkhaus. David folgt den Hinweisen des Mannes der die Maschine gebaut hat und findet den Ort den dieser offenbar kannte.

### Die Kammer

Immer am selben Ort. Immer zugänglich nach Freischaltung. Zu groß für das Gebäude drum herum. Kein Musik — nur leises Atmen. Fühlt sich an als wäre sie außerhalb der Zeit.

Fünf Händler. Unabhängig voneinander. Unabhängig von Herr K.

Und in einer Ecke: Herr K. Sitzt. Beobachtet. Sagt nichts — bis zum Ende.

**Hauptwährung:** Schwarzmarktmünzen — aus verbotenen Artefakten und bestimmten Epochen-Drops.

### Herr K. in der Kammer

- Sitzt immer in derselben Ecke
- Beobachtet alle Transaktionen schweigend
- Reagiert minimal auf bestimmte Artefakte — kleine Details für aufmerksame Spieler
- Spricht nie — bis David am Ende versteht wer er ist
- Dann erklärt er sich kurz, ruhig, ohne Drama
- Danach verschwindet er einfach

### Verkaufen — an wen?

In der Kammer können Artefakte an den Kurator (Händler 4) verkauft werden sowie Schwarzmarktmünzen durch andere Transaktionen verdient werden.

| Kategorie | Preis | Notiz |
|-----------|-------|-------|
| Verbotene Artefakte | Gut | Hauptinteresse |
| Doppelte Exponate | Wenig | Nimmt nur eines |
| Fragmentartefakte | Sehr wenig | — |
| Lebendige Exponate | — | *„Damit handel ich nicht."* |
| Paradoxartefakte | Enorm | Selten — Händler reagieren ungewöhnlich |

---

### Händler 1 — Die Uhrmacherin

Geheime Zeitmaschinen-Upgrades die offiziell nicht existieren.

| Artikel | Effekt | Kosten |
|---------|--------|--------|
| Temporaler Splitter | Kurzes Gleiten in Parallelzeitlinien | Schwarzmarktmünzen |
| Echtzeitanker | Rückweg kürzt sich automatisch | Schwarzmarktmünzen |
| Verschleierungsmodul | Keine Signatur mehr | Schwarzmarktmünzen |
| Überbrückungskern | Ein Sprung ohne Ankerenergie — Einmalverwendung | Schwarzmarktmünzen |
| Gestohlene Schaltpläne | Braucht Dr. Amara — Ergebnis unbekannt | Schwarzmarktmünzen |

---

### Händler 2 — Der Archivar

Namenlos und mysteriös. Redet nie. Schiebt Umschläge über den Tisch. Woher er die Informationen hat ist unklar.

| Artikel | Effekt | Kosten |
|---------|--------|--------|
| Vollständige Epochenkarte | Kompletter Grundriss vorab | Schwarzmarktmünzen |
| Dynamische Patrouillenroute | Echtzeit-Gegnerbewegungen eine Nacht | Schwarzmarktmünzen |
| Artefaktlokalisierung | Alle Positionen + versteckte | Schwarzmarktmünzen |
| Bossanalyse | Alle Phasen und Schwachstellen | Schwarzmarktmünzen |
| Personalakte | Hintergrund zu Mitarbeitern — eine erschreckend | Schwarzmarktmünzen |
| Zukünftige Schicht | Andere Zeit = andere Gegner, andere Artefakte | Schwarzmarktmünzen |

---

### Händler 3 — Die Waffenschmiedin

Kampfwerkzeuge die nirgendwo sonst erhältlich sind.

| Artikel | Effekt | Kosten |
|---------|--------|--------|
| Zeitnadel | Gegner kurz einfrieren | Schwarzmarktmünzen |
| Resonanzklinge | Schneidet durch historische Rüstungen | Schwarzmarktmünzen |
| Nebelkapsel | Alle Sichtlinien brechen | Schwarzmarktmünzen |
| Entladungshandschuh | Massive Schockwelle — Reparatur danach | Schwarzmarktmünzen |
| Anonyme Pistole | Keine Herkunft — Herr K. schaut kurz auf | Schwarzmarktmünzen |

---

### Händler 4 — Der Kurator

Kauft und verkauft Artefakte. Hat manchmal Artefakte die David bereits besessen hat. Woher — besser nicht laut fragen.

| Regel | Detail |
|-------|--------|
| Kauft nur gute Qualität | Fragmente abgelehnt |
| Dreier-Set Bonus | Zahlt mehr für drei aus derselben Epoche |
| Verkauft unbekannte Artefakte | Enormer Ruhm — Lena stellt Fragen |
| Zahlt in Schwarzmarktmünzen | Manchmal auch in etwas Unerwartetem |

---

### Händler 5 — Das Kind

Kein Name. Sitzt immer in derselben Ecke. Redet nie. Verkauft Dinge die keiner der anderen verkaufen würde.

| Artikel | Effekt | Kosten |
|---------|--------|--------|
| Ruhenacht-Kompresse | Alle Konditionsmarker sofort voll | Schwarzmarktmünzen |
| Gedächtnislöschung | Risikostufe 2 Wochen eingefroren | Schwarzmarktmünzen |
| Parallelecho | Version von David hilft eine Nacht — sagt nichts, sieht erschöpft aus | Schwarzmarktmünzen |
| Stabilitätskern | Instabilitätswert sofort auf null | Schwarzmarktmünzen |
| Das Angebot | Kostet nichts. Unbekannt bis zur Annahme. | — |

---

### Risikosystem

Je mehr verbotene Transaktionen desto höher das Risiko:

| Stufe | Ereignis |
|-------|----------|
| 1 | Einer der Händler erwähnt beiläufig dass jemand fragt |
| 2 | Ein Exponat verschwindet über Nacht spurlos |
| 3 | Unbekannte Partei sucht David |
| 4 | Die Kammer ist beim nächsten Besuch leer — Händler weg |
| 5 | Das Kind sitzt noch da. Herr K. sitzt noch da. |

---

## 18. Epochen

10–15 im Release. Handgecrafted, fest. Reihe nach freischaltbar. Revisitierbar — Boss nur einmal. Jede visuell + klanglich komplett anders.

### Urzeit
Dinosaurierzeit · Mammutjäger · Steinzeit

### Antike
- Europa: Griechen · Spartaner · Römer · Kelten
- Afrika: Ägypter · Phönizier
- Naher Osten: Babylonier · Perser
- Amerika: Maya

### Frühmittelalter
- Europa: Wikinger · Byzantiner
- Asien: Samurai · Shaolin · Khmer · Assassinen
- Amerika: Azteken · Inka
- Afrika: Mali-Krieger

### Hochmittelalter
- Europa: Kreuzritter
- Asien: Ninja · Osmanen · Mongolen · Mogul
- Amerika: Indianer · Zulu

### Frühe Neuzeit
- Europa: Napoleonische Soldaten · Viktorianische Gentlemen
- Amerika: Piraten · Colonien
- Weltweit: Weltkrieg · Kalter Krieg · 70er/80er

### Spekulativ
Atlantis · Camelot · El Dorado

### Zukunft
Nahe Zukunft · Ferne Zukunft · Nach dem Ende

---

## 19. Dialoge und Narrative

**System:** Vollständige Dialogbäume

**Wie David mehr erfährt:**
Ausschließlich Tagebucheinträge — nur im Journal, nur im Museum lesbar. NPCs wissen nichts.

**NPC-Besonderheiten:**
- Viktor kommentiert jedes Exponat — oft falsch, manchmal beleidigend
- Lena stellt häufiger Fragen je mehr verbotene Artefakte da sind
- Dr. Amara erwähnt Dinge die sie nicht wissen könnte
- Händler in der Kammer reden minimal — zweckorientiert
- Herr K. redet nicht — bis zum Ende
- Das Kind redet nie
- Bruno merkt nichts. Macht Tee.

**Format:** Textboxen + Charakterportrait · Wählbare Antworten · Kein Voice Acting v1.0

---

## 20. Audio

| Bereich | Stil |
|---------|------|
| Museum Tagphase | Ruhig, melancholisch, Kammermusik |
| Keller / Maschine | Tief, mechanisch, unheimlich |
| 1800er–1900er | Viktorianisch, Blechbläser |
| Mittelalter | Gregorianisch, Laute, Trommel |
| Römer / Griechen | Fanfaren, Lyra, Marschrhythmus |
| Samurai / Japan | Shamisen, Koto, Shakuhachi |
| Wikinger | Drohnenklang, Kriegstrommeln |
| Prähistorie | Nur Geräusche und Drones |
| Bosskampf | Intensiv, epochentypisch, Crescendo |
| Museum nachts | Stille — Schritte + Heizung |
| Die Kammer | Kein Musik — nur leises Atmen |

**Sound Design:**
- Maschine klingt anders mit jedem Upgrade
- Instabilitätswert durch Verzerrungen hörbar
- Artefakt-Glow hat subtilen Ton
- Tagebucheintrag-Fund: eigenes ruhiges Motiv
- Kammer-Betreten: Sound verändert sich — Stille die sich anders anfühlt

---

## 21. Visuelles Design

**Stil:** Pixel Art — TBD
**Museum:** Dunkel, warme Akzentfarben
**Epochen:** Jede komplett anders

| Bereich | Charakter |
|---------|-----------|
| Museum | Dunkel, warm, verstaubt, Goldakzente |
| Keller | Kalt, mechanisch, schwaches Licht |
| Die Kammer | Leer wirkend, zu groß, Licht kommt von nirgendwo |
| 1800er | Sepia, Gaslicht |
| Ägypten | Sand, Gold, tiefes Blau |
| Samurai | Kirschblüten, Nebel |
| Wikinger | Grau, Eis, Feuer |
| Prähistorie | Erdtöne, kein künstliches Licht |
| Zukunft | Neon, kaputte Technologie |

---

## 22. Speichersystem

**Automatisch nach jeder Nacht. Mehrere Speicherslots.**

Gespeichert wird: Museumname + Zustand · Artefaktpositionen · Maschinen-Upgrades · Keller-Fortschritt · Währungen · Fähigkeiten · Dialogfortschritt · Journal · Risikostufe · Freigeschaltete Epochen · Kammer-Fortschritt

---

## 23. Steam Achievements

| Kategorie | Beispiele |
|-----------|-----------|
| **Story** | Erste Nacht überleben · Kammer finden · Letzten Eintrag finden · Ende erreichen |
| **Sammeln** | X Artefakte ausgestellt · Alle Epochen besucht · Geheimboss besiegt · Paradoxartefakt verkauft |
| **Museum** | Museum voll ausgebaut · Alle Mitarbeiter · Weltruhm · Brand überlebt |
| **Kampf** | Jeden Boss-Typ besiegt · X Nächte ohne Tod · Das Angebot angenommen |

---

## 24. Ende und Abschluss

**Endbedingung:** Museum erreicht Weltruhm-Schwellenwert (TBD)

David findet den letzten Tagebucheintrag in der tiefsten erreichbaren Epoche. Er versteht was der Wissenschaftler entdeckt hat. Er erkennt wer Herr K. ist.

Herr K. erklärt sich — kurz, ruhig. Dann verschwindet er einfach.

**Endwahl:**

| Wahl | Ende |
|------|------|
| Maschine zerstören | Credits · Museum bleibt · Herr K. weg · Kammer leer |
| Maschine behalten | Credits · Museum bleibt · Kammer offen · Neue Notiz im Keller |

*Was in der letzten Notiz steht: TBD*

---

## 25. Geschäftsmodell

| Plattform | Modell | Preis |
|-----------|--------|-------|
| PC (Steam) | Einmalkauf | 14,99 € |
| Mobile iOS | Einmalkauf + optionale DLCs | TBD |
| Mobile Android | Einmalkauf + optionale DLCs | TBD |

**DLC-Ideen:**
- Neue Epochenpakete
- Neue Story-Kapitel + Tagebucheinträge
- Neue Kammer-Händler
- Neue Mitarbeiter mit eigenen Dialogbäumen
- Kosmetische Packs

---

## 26. Offene Punkte (TBD)

- Pixel-Art-Stil
- Was der Wissenschaftler über den Ursprung der Zeit entdeckt hat
- Was Herr K. am Ende genau sagt
- Was in der letzten Notiz steht
- Welche 10–15 Epochen konkret im Release
- Genaue Ruhmpunktschwelle für Spielende
- Respawn-Timing Gegner (nach X Nächten)
- Inhalt verschlossener Kellertüren
- Durch Events getriggerte zusätzliche NPCs
- Rollenverteilung im Team
- Mobile Preise
- Cloud Save
- Lokalisierungen nach Englisch

---

*Last Exhibit — GDD v0.6*
*Team: Alexander Gese · Paul Korn · Fabian Wolf · Johannes Schneider*
*Engine: Godot 4.x · PC 14,99 € · Mobile Einmalkauf + DLC · Singleplayer · Englisch*
*Ziel-Release: 3 Monate · Controller-Support · Steam Achievements (Story / Sammeln / Museum / Kampf)*
