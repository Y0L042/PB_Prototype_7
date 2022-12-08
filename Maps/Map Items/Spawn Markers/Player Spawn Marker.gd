extends Marker2D


var _parent
@export var _troops: Array[Resource] : get = get_troops

func _ready() -> void:
	_parent = get_parent()
	_spawn_players()

func _spawn_players():
	await get_tree().create_timer(1.0).timeout

	var _spawn_point: Vector2 = get_global_position()
	var army = SceneLib.spawn_child(SceneLib.PLAYER_ARMY, get_tree().get_root(), _spawn_point)
	army.set_army_position(_spawn_point)
	for troop in _troops:
		army.set_initial_troop(troop)



func get_troops():
	return _troops


