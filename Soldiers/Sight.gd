extends Area2D

var sightings: Array
var sighted_enemy = null
#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _on_body_entered(body: Node2D) -> void:
	sightings.append(body)
	if sighted_enemy != null \
	and get_global_position().distance_squared_to(body.get_global_position()) \
	< get_global_position().distance_squared_to(sighted_enemy.get_global_position()):
		sighted_enemy = body

func _on_body_exited(body: Node2D) -> void:
	sightings.erase(body)
	if sighted_enemy == body:
		if !sightings.is_empty():
			sighted_enemy = sightings[0]
		else:
			sighted_enemy = null
