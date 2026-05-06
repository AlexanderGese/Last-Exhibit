# Inventar-System — Quick Guide

Alle Mutationen laufen über den `SaveManager` (Autoload). UI hört auf das Node-Signal `SaveManager.inventory_changed`.

## Aufheben (Player drückt **E** auf einem Pickup)

Pickup-Szene: `res://custom_nodes/ItemPickUp/ItemPickup.tscn`. Zum Spawnen:

```gdscript
var pickup := preload("res://custom_nodes/ItemPickUp/ItemPickup.tscn").instantiate()
pickup.item = preload("res://inventory/items/whiskey.tres")
add_child(pickup)
pickup.global_position = Vector2(100, 200)
```

Sobald der Player im Area2D ist und `interact` (Standard: E) drückt:
- **Equipment** (HEAD/BODY/LEGS/FEET/WEAPON): wird sofort angelegt. War im Equip-Slot schon was drin → das alte Item droppt am Player.
- **Sonstiges**: wird ins Inventar gestapelt. Wenn voll → Pickup bleibt liegen.

## Droppen aus dem Inventar

**Rechtsklick** auf einen Inventar-Slot droppt 1 Stück am Player. Der Stack zählt runter, bei `qty == 1` wird der Slot leer.

Programmatic:
```gdscript
SaveManager.drop_item(slot_index)
```

Der Player hört intern auf das Signal `SaveManager.item_dropped(item)` und spawnt die `ItemPickup`-Szene an seiner Position. Das frische Pickup ist 0.5s lang nicht aufhebbar (sonst sofortiger Re-Pickup).

## Equipment ausrüsten (aus dem Inventar)

```gdscript
SaveManager.equip(slot_index)     # programmatic
```

UI: Doppelklick auf Slot, oder `hotkey_1`..`hotkey_7`.

## Item per Code hinzufügen (z. B. Quest-Reward)

```gdscript
SaveManager.add_item(item_resource)        # 1 Stück
SaveManager.add_item(item_resource, 5)     # 5 (stackt auto)
```

Returns `bool`: `true` wenn alles reingepasst.

## Neues Item anlegen

1. FileSystem-Dock → Rechtsklick → **New Resource…** → `Item`
2. Speichern unter `res://inventory/items/<name>.tres`
3. Felder im Inspector setzen:
   - `id` — eindeutiger String (für Stacking)
   - `name`, `icon`, `type` (siehe `Item.Type`-Enum)
   - `stackable` + `max_stack`
   - `value`

## Pickup-Node in der Welt platzieren

1. `ItemPickup.tscn` als Kind in deinen Level-Node ziehen (oder per Code instanzieren).
2. Im Inspector `item` auf das gewünschte `Item.tres` setzen — das Sprite übernimmt automatisch das Icon.
3. CollisionShape2D-Größe ggf. anpassen (default ist eine kleine RectangleShape2D).

## Direkter Resource-Zugriff

❌ `SaveManager.inventory.add_item(...)` — UI bekommt kein Signal!
✅ `SaveManager.add_item(...)`

Nur lesen ist okay: `SaveManager.inventory.slots`, `SaveManager.inventory.equipped`, `SaveManager.inventory.gold`.

## Inputs

| Action | Default | Wirkung |
|--------|---------|---------|
| `interact` | **E** | Pickup aufheben |
| `hotkey_1`..`hotkey_7` | 1..7 | Slot 0..6 ausrüsten |
| Doppelklick auf Slot | LMB | Ausrüsten |
| Rechtsklick auf Slot | RMB | 1× droppen |
