extends Army

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Input Variables
#-------------------------------------------------------------------------------
var _rotate_formation_dir: int = 0
@onready var _increment_width_cooldown_timer = get_tree().create_timer(1.0)


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
func _custom_ready() -> void:
#	formation.set_volume(0)
#	formation.set_width(3)
	set_y_sort_enabled(true)


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _custom_process(delta: float):
	_move_army()
	_smooth_input_handling()
	play_marching()


func _move():
#	clamp_army_position() #testing clamping
#	return #testing clamping
	var delta: float = _delta
	_army_position += _army_velocity * delta
	formation.set_center_position(_army_position)


func clamp_army_position(): # testing clamping
	# clamps _army_position to (near) the actual location of the army
	# it is not perfect; it works like a joystick.
	# It will still trigger enemy armies, even when your soldiers are further away
	# It will also escape enemy armies easier
	# Decision pending if this system should be changed

	var LENGTH: float = 6 * GlobalSettings.UNIT
	var LERP_STRENGTH: float = 0.1
	var delta: float = _delta
	var army_center: Vector2 = _calc_soldier_array_center()#_soldier_manager.active_soldiers_array)
	var target: Vector2 = army_center + _army_velocity.normalized() * LENGTH
	if _army_velocity != Vector2.ZERO:
		_army_position = lerp(_army_position, target, LERP_STRENGTH)
	else:
		_army_position = target
#	_army_position = lerp(_army_position, target, LERP_STRENGTH) if _army_velocity != Vector2.ZERO else target
	formation.set_center_position(_army_position)
#	formation.set_center_position(lerp(army_center, _army_position, 0.5))


func play_marching():#temp
	#play marching sound, temp
	audio_stream.set_global_position(_army_position)
	if _army_velocity.length_squared() > 15*15:
		if !audio_stream.is_playing():
			audio_stream._set_playing(true)
	else:
		audio_stream.stop()

#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	# formation rotation
	var rot_clockwise: int = int(Input.is_action_pressed("game_action_rotate_f_clockwise"))
	var rot_anticlockwise: int = int(Input.is_action_pressed("game_action_rotate_f_anticlockwise")) * -1
	_rotate_formation_dir = rot_clockwise + rot_anticlockwise

	# formation width
	if _increment_width_cooldown_timer.get_time_left() <= 0:
		var formation_stretch: int = int(Input.is_action_pressed("game_action_f_stretch"))
		var formation_squash: int = int(Input.is_action_pressed("game_action_f_squash")) * -1
		if (formation_stretch + formation_squash) != 0:
			formation.increment_width(formation_stretch + formation_squash)
			_increment_width_cooldown_timer = get_tree().create_timer(0.25)



func _smooth_input_handling():
	rotate_formation()
#	_set_formation_rotation()

func army_is_dead():
	set_physics_process(false)
	activate_game_over()

func activate_game_over():
	SceneManager._root_manager.GameOver.emit()
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
		formation.increment_rotation(deg_to_rad(rotation_increment * _rotate_formation_dir))


#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#


