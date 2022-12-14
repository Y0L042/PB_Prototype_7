extends Area2D



@onready var _parent = get_parent()
var sightings: Array
var sighted_enemy = null : get = get_sighted_enemy

func get_sighted_enemy():
	if sightings.is_empty(): return null
	sighted_enemy = sightings[0]

	# OPTIMIZATION test
	if _parent.get_global_position().distance_squared_to(sightings.front().get_global_position()) \
	> _parent.get_global_position().distance_squared_to(sightings.back().get_global_position()):
		sighted_enemy = sightings.back()
	return sighted_enemy

	for enemy in sightings:
		if _parent.get_global_position().distance_squared_to(enemy.get_global_position()) \
		< get_global_position().distance_squared_to(sighted_enemy.get_global_position()):
			sighted_enemy = enemy
	return sighted_enemy

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _on_body_entered(body: Node2D) -> void:
	if body.faction == _parent.faction: return
	sightings.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body.faction == _parent.faction: return
	sightings.erase(body)

