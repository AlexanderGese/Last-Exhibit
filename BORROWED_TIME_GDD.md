# Borrowed Time
### Game Design Document v0.1

> *A 2D Metroidvania with idle/clicker progression. You are a night watchman with a time machine in his basement. Every night you raid history. Every day the museum opens.*

---

## Table of Contents

1. [Concept](#1-concept)
2. [Core Loop](#2-core-loop)
3. [The Two Dimensions](#3-the-two-dimensions--zeittiefe--expeditionsradius)
4. [Currencies](#4-currencies)
5. [The Time Machine](#5-the-time-machine)
6. [Expedition & Combat](#6-expedition--combat)
7. [The Museum](#7-the-museum)
8. [The Black Market](#8-the-black-market)
9. [Antagonist — The Inspector](#9-antagonist--the-inspector)
10. [Tone & Atmosphere](#10-tone--atmosphere)

---

## 1. Concept

You play as a night watchman at a tiny, half-empty museum on the verge of closure. In the third week on the job you found a time machine behind a false wall in the basement. There was a note on it: *"Please do not use."*

You used it immediately.

Every night you travel to a different historical epoch, fight your way through ruins, palaces, and battlefields, and steal whatever you can carry. You return before dawn. During the day, tourists pay to see what you brought back.

The museum grows. The time machine gets stranger. Someone is starting to notice.

---

## 2. Core Loop

```
NIGHT BEGINS
    │
    ▼
Choose epoch + set Zeittiefe & Expeditionsradius
    │
    ▼
Travel — 2D Metroidvania exploration
    │
    ├── Fight guards, soldiers, creatures
    ├── Collect artefacts (small / medium / large / living / forbidden / fragmented)
    ├── Find Time Shards, Wegmarken, Kartenfragmente
    └── Defeat boss → claim prime artefact
    │
    ▼
Return before dawn (time limit based on machine upgrades)
    │
    ▼
DAY PHASE
    │
    ├── Place artefacts in museum
    ├── Passive income runs (Eintrittsgeld, Spendengelder, Forschungsbudget)
    ├── Staff work passively
    ├── Restauratorin repairs fragments
    └── Upgrade museum, time machine, or equipment
    │
    ▼
NIGHT BEGINS AGAIN
```

---

## 3. The Two Dimensions — Zeittiefe & Expeditionsradius

Every expedition has two independent dials. Both are upgraded separately, both carry separate risk.

### Zeittiefe — How Far Back

How deep into the past you travel. The further back, the stranger and more dangerous.

| Stufe | Epoch Range | Notes |
|-------|-------------|-------|
| 1 | 1800s–1900s | Familiar, guards in uniform |
| 2 | Medieval–Renaissance | Castles, knights, alchemists |
| 3 | Antiquity | Rome, Egypt, Greece |
| 4 | Ancient Civilisations | Aztec, Viking, Feudal Japan |
| 5 | Prehistory | No language, no map logic |
| 6 | ??? | Unlocked via black market only |

### Expeditionsradius — How Far You Roam

How far from your anchor point you travel within the epoch. The further you go, the larger the map, the rarer the artefacts, and the harder the return.

### Interaction Matrix

| | Low Radius | High Radius |
|---|---|---|
| **Low Zeittiefe** | Safe, low reward | Known enemies, long walk back |
| **High Zeittiefe** | Far back, close anchor — manageable | Maximum danger, maximum reward |

### Instability Value

Both dimensions together build an **Instabilitätswert** each night:

| Level | Effect |
|-------|--------|
| Low | Normal |
| Medium | Enemies react faster, anchor flickers |
| High | Map distorts, shortcuts disappear |
| Critical | Rift opens — special boss spawns, return costs double Ankerenergie |
| Overflow | Machine breaks down, one night lost to repairs |

---

## 4. Currencies

### Zeittiefe Currencies

| Currency | Source | Used For |
|----------|--------|----------|
| **Time Shards** | Boss drops, rare enemies | Basic Zeittiefe upgrades |
| **Chronostaub** | Deep epochs only | Advanced time upgrades |
| **Paradoxsplitter** | Doing things that shouldn't happen | Most powerful time upgrades — risky to collect |
| **Ankerenergie** | Regenerates passively in museum | Stabilises return journey |

### Expeditionsradius Currencies

| Currency | Source | Used For |
|----------|--------|----------|
| **Wegmarken** | Collected while exploring, more the further you go | Radius upgrades |
| **Kartenfragmente** | Chests and enemies | Passive map building |
| **Ausdauerkristalle** | Physical resource, determines nightly range | Endurance upgrades |
| **Bergungspunkte** | Earned by returning with heavy loads | Carry capacity upgrades |

### Museum Currencies

| Currency | Source | Used For |
|----------|--------|----------|
| **Eintrittsgeld** | Daily visitors, scales with prestige | Most museum upgrades |
| **Spendengelder** | Wealthy visitors, triggered by rare exhibits | Large expansions |
| **Forschungsbudget** | Documentation, school programmes | Knowledge upgrades |
| **Ruhmpunkte** | Not spent — determines visitor count and events | Passive multiplier |
| **Schwarzmarktmünzen** | Forbidden artefacts, shady dealers | Black market only |
| **Betriebskosten** | *Negative currency* — rises with museum size | Must be covered or museum closes early |

### Combat Currencies

| Currency | Source | Used For |
|----------|--------|----------|
| **Konditionsmarker** | Your health per night | Restored only by rest nights or special items |
| **Ausrüstungsschlitze** | Limited slots | Determines what you can bring |
| **Erfahrungswissen** | Accumulates per epoch | Makes enemies more predictable |
| **Beute-Effizienz** | Successful heavy returns | Influences long-term Bergungspunkte |

---

## 5. The Time Machine

Found in the basement. Disguised as a boiler. It is not a boiler.

### Zeittiefe Upgrades

| Upgrade | Effect | Cost |
|---------|--------|------|
| Zeitreichweite Stufe 1–6 | Unlocks earlier epochs | Time Shards |
| Temporale Dämpfung | Reduces paradox risk during stay | Chronostaub |
| Ankervertiefung | Anchor stays stable further back | Ankerenergie |
| Zeitpuffer | Longer stay before stability loss | Time Shards |
| Notanker | Instant return on danger — long cooldown | Paradoxsplitter |
| Doppelschicht | Two time layers per night — extremely