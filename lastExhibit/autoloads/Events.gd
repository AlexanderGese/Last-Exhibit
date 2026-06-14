extends Node
# Events.gd

signal purchase_großanzeigen(type: String)
signal artifact_placed(floor_name: String)
signal visitor_spawned
signal visitor_left
signal standing_in_showcase(number: int)

signal used_artifact(Artifact: Item, index:int)
signal artifact_place(i: int)
signal upgrade_purchased(type: String)
signal upgrade_collected(type: String)

signal sw_boss_dead()
