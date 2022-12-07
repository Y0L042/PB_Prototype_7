extends Marker2D


var _parent
var _troops: Array = []

func _ready() -> void:
	_parent = get_parent()
	_troops = _parent.get_troops()
	_spawn_players()

func _spawn_players():
	var _spawn_point: Vector2 = get_global_position()
	var army = SceneLib.spawn_child(SceneLib.PLAYER_ARMY, get_tree().get_root(), _spawn_point)
#	army.set_army_position(_spawn_point)
	for troop in _troops:
		army.set_initial_troops(troop)

