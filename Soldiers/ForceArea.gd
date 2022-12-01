extends Area2D


#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
@onready var _parent = get_parent()


#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
var contact_bodies: Array = []
var contacts: Array = []
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
func get_collision_sum():
	var sum := Vector2.ZERO
	for contact in contacts:
		sum += contact
	return sum

func get_collision_average_direction():
	var sum: Vector2 = get_collision_sum()
	sum /= contacts.size()
	sum = Vector2.ZERO if contacts.is_empty() else sum.normalized()
	return sum
#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _on_body_entered(body: Node2D) -> void:
	if body == get_parent(): return
	if body.get_parent().faction != get_parent().faction: return
#	if body.get_parent().faction != "hello": return
#	if "hello" != get_parent()._faction: return
	contact_bodies.append(body)
	contacts.append(body.get_global_position())


func _on_body_exited(body: Node2D) -> void:
	var index: int = contact_bodies.find(body)
	if index == -1: return
	contact_bodies.erase(body)
	contacts.remove_at(index)
