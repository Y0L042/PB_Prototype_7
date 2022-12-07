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
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

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
	contact_bodies.append(body)
	contacts.append(body.get_global_position())


func _on_body_exited(body: Node2D) -> void:
	var index: int = contact_bodies.find(body)
	if index == -1: return
	contact_bodies.erase(body)
	contacts.remove_at(index)


func _on_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body == get_parent(): return
	contact_bodies.append(body)
	contacts.append(body.get_global_position())


func _on_area_exited(area: Area2D) -> void:
	var body = area.get_parent()
	var index: int = contact_bodies.find(body)
	if index == -1: return
	contact_bodies.erase(body)
	contacts.remove_at(index)
