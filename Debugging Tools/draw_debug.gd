extends Node2D

class_name VisualDebugger


#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var _parent


#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
var debug_array: Array = []
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#


#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _init(new_parent) -> void:
	_parent = new_parent
	_parent.add_child(self)
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _process(delta: float) -> void:
	queue_redraw()

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func _draw() -> void: #%Debug
	pass

#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Debug Draw
#-------------------------------------------------------------------------------
func debug_draw_grid_dots(
	grid: Array,
	new_col = Color(0, 0, 1),
	new_rad = int(GlobalSettings.UNIT/2)
	):
	var col = new_col
	var rad = new_rad
	for spot in grid:
		draw_circle(spot, rad, col)

func debug_draw_dot(
	new_pos: Vector2,
	new_col = Color(0, 0, 1),
	new_rad = int(GlobalSettings.UNIT/2)
	):
	var col = new_col
	var rad = new_rad
	draw_circle(new_pos, rad, col)



func debug_draw_line(
	start: Vector2,
	end: Vector2,
	new_col = Color(0, 1, 1),
	new_width: float = 0.1
	):
	var col = new_col
	var width = new_width
	end += start
	draw_line(start, end, col, width)






