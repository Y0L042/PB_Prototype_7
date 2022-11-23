extends Army

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Input Variables
#-------------------------------------------------------------------------------
var _rotate_formation_dir: int = 0


#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#

#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#


#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	_formation.set_number_of_positions(9)
	_formation.set_width(3)


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _custom_process(delta: float):
	_move_army()
	_smooth_input_handling()

	_draw_debug()


#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	# formation rotation
	var rot_clockwise: int = int(Input.is_action_pressed("game_action_rotate_f_clockwise"))
	var rot_anticlockwise: int = int(Input.is_action_pressed("game_action_rotate_f_anticlockwise")) * -1
	_rotate_formation_dir = rot_clockwise + rot_anticlockwise

func _smooth_input_handling():
	rotate_formation()
#	_set_formation_rotation()

#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------
func _move_army():
	const DEADZONE: float = 0.5 # move to control settings
	var _input_vec: Vector2 = Input.get_vector("game_action_left", "game_action_right", "game_action_up", "game_action_down", DEADZONE)
	_army_velocity = _input_vec * army_speed
	_move()

#-------------------------------------------------------------------------------
# Formation Functions
#-------------------------------------------------------------------------------
func rotate_formation():
	var rotation_increment: float = 180 * _delta
	if _rotate_formation_dir != 0:
		_formation.increment_rotation(deg_to_rad(rotation_increment * _rotate_formation_dir))


#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#

#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
func _draw() -> void: #%Debug

	_debug_draw_army_rotation()
	_debug_draw_army_position(get_army_position())
	_debug_draw_army_velocity(get_army_position(), _army_velocity)

	_debug_draw_army_formation()

func _debug_draw_army_formation():
	var col = Color(1, 1, 0)
	var rad = int(GlobalSettings.UNIT/2)
	_debug_draw_grid_dots(_formation.vector_array, col, rad)


func _debug_draw_army_position(new_pos):
	var col = Color(1, 0, 0)
	var rad = int(GlobalSettings.UNIT/2)
	_debug_draw_dot(new_pos, col, rad)


func _debug_draw_army_velocity(start, end):
	var col = Color(0, 0, 1)
	var width = 0.1
	_debug_draw_line(start, end, col, width)

func _debug_draw_army_rotation():
	var start: Vector2 = _army_position
	var end: Vector2 = Vector2.RIGHT.rotated(_formation.rotation) * 2 * GlobalSettings.UNIT
	var col = Color(1, 0, 1)
	var width = 100
	_debug_draw_line(start, end, col, width)
