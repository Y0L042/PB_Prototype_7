extends Node2D

class_name Army

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var _delta: float
var _army_position: Vector2 = Vector2.ZERO : set = set_army_position
var _army_velocity: Vector2 = Vector2.ZERO


#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# "Features"
#-------------------------------------------------------------------------------
var blackboard: Dictionary = {
	"formation" : GridObject.new(),

	"move_order" : Vector2.ZERO,
}
@onready var army_sight_area: Area2D = %Army_Sight
@onready var formation = blackboard.formation
#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export_color_no_alpha var army_colour: Color # used with outline shader
@export var army_speed: float : set = set_army_speed
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_army_position(new_army_position: Vector2):
	_army_position = new_army_position
	# update move_order
	blackboard.move_order = _army_position
	formation.center_position = _army_position
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
	formation.set_center_position(_army_position)

#-------------------------------------------------------------------------------
# Formation Functions
#-------------------------------------------------------------------------------
func _set_formation_rotation():
	if _army_velocity != Vector2.ZERO:
		formation.set_rotation(_army_velocity.angle())




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
func _draw_debug():
	queue_redraw()

func _draw() -> void: #%Debug
	pass

func _debug_draw_grid_dots(
	grid: Array,
	new_col = Color(0, 0, 1),
	new_rad = int(GlobalSettings.UNIT/2)
	):
	var col = new_col
	var rad = new_rad
	for spot in grid:
		draw_circle(spot, rad, col)

func _debug_draw_dot(
	new_pos: Vector2,
	new_col = Color(0, 0, 1),
	new_rad = int(GlobalSettings.UNIT/2)
	):
	var col = new_col
	var rad = new_rad
	draw_circle(new_pos, rad, col)

func _debug_draw_line(
	start: Vector2,
	end: Vector2,
	new_col = Color(0, 1, 1),
	new_width: float = 0.1
	):
	var col = new_col
	var width = new_width
	end += start
	draw_line(start, end, col, width)
