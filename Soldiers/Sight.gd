extends Area2D

@onready var _parent = get_parent()
var sightings: Array
var sighted_enemy = null

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _on_body_entered(body: Node2D) -> void:
	if body.faction == _parent.faction: return
	sightings.append(body)
	if sighted_enemy != null \
	and get_global_position().distance_squared_to(body.get_global_position()) \
	< get_global_position().distance_squared_to(sighted_enemy.get_global_position()):
		sighted_enemy = body
	elif sighted_enemy == null:
		sighted_enemy = body

func _on_body_exited(body: Node2D) -> void:
	if body.faction == _parent.faction: return
	sightings.erase(body)
	if sighted_enemy == body:
		if !sightings.is_empty():
			sighted_enemy = sightings[0]
		else:
			sighted_enemy = null
