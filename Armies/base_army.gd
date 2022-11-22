extends Node2D

class_name Army

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var _delta: float
var _army_position: Vector2 = Vector2.ZERO : set = set_army_position
var _army_velocity: Vector2 = Vector2.ZERO
@onready var _formation = blackboard.formation

#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
var blackboard: Dictionary = {
	"formation" : GridObject.new(),

	"move_order" : Vector2.ZERO,
}

@export_color_no_alpha var army_colour: Color
@export var army_speed: float : set = set_army_speed
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_army_position(new_army_position: Vector2):
	_army_position = new_army_position
	# update move_order
	blackboard.move_order = _army_position
	_formation.center_position = _army_position
func get_army_position():
	return _army_position

func set_army_speed(new_army_speed: float):
	army_speed = new_army_speed
	army_speed *= GlobalSettings.UNIT



#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	_delta = delta
	_custom_process(delta)

@warning_ignore(unused_parameter)
func _custom_process(delta: float):
	pass

#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------
func _move():
	var delta: float = _delta
	_army_position += _army_velocity * delta

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func _calc_soldier_array_center(arr: Array):
	var avg := Vector2.ZERO
	for soldier in arr:
		avg += soldier.get_global_position()
	avg /= arr.size()
	return avg


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#

#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
