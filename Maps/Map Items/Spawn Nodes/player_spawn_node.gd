extends Node2D


func _spawn_players():
	for child in get_children():
		var _spawn_point: Vector2 = child.get_global_position()
		var army = SceneLib.spawn_child(SceneLib.PLAYER_ARMY, self)

		army.set_army_position(_spawn_point)
