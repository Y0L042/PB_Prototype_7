extends Marker2D


var _parent
@export var _troops: Array[Resource] : get = get_troops

func _init() -> void:
	add_to_group(SceneLib.Map_Item_Group)

func start_map_item() -> void:
	_parent = get_parent()
	_spawn_players()

func _spawn_players():
	await get_tree().create_timer(1.0).timeout

	var _spawn_point: Vector2 = get_global_position()
	var army = SceneLib.spawn_child(SceneLib.PLAYER_ARMY, SceneManager._root_manager.current_map, _spawn_point)
	army.set_army_position(_spawn_point)
	for troop in _troops:
		army.set_initial_troop(troop)



func get_troops():
	return _troops


