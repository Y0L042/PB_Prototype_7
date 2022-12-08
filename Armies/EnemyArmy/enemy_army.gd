extends Army

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
@export @onready var _ai_module: Resource : set = set_ai_module



#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#

#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_ai_module(new_ai_module):
	if new_ai_module == null:
		print("Error: AI module scene is empty!", self)
		return -1
	_ai_module = new_ai_module
	_ai_module.set_parent(self)
	_ai_module_ready()

#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _custom_ready() -> void:
#	_ai_module_ready()
	pass



func _ai_module_ready():
	# Run AI Module _ready
	if _ai_module != null:
		_ai_module.ai_module_ready()

	formation.set_volume(9)
	formation.set_width(3)


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _custom_process(delta: float):
	_ai_module_process(delta)
	_set_formation_rotation()
	_debug()
	play_marching()

func play_marching():#temp
	audio_stream.set_global_position(_army_position)
	audio_stream.set_volume_db(-10)
	#play marching sound, temp
	if _army_velocity.length_squared() > 15*15:
		if !audio_stream.is_playing():
			audio_stream._set_playing(true)
	else:
		audio_stream.stop()

func _ai_module_process(delta: float):
	# Run AI Module _physics
	if _ai_module != null:
		_ai_module.ai_module_physics_process(delta)

#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------
func _collision_avoidance_adjust(current_position, current_direction, new_distance, new_degree_offset = 36):
	var distance = new_distance * GlobalSettings.UNIT
	var new_dir: Vector2 = current_direction
	var offset: float = deg_to_rad(new_degree_offset)
	var isRaycastIntersected: bool = !_do_line_raycast(current_position, current_position+(new_dir*distance), GlobalSettings.COL_LAYER.WORLD).is_empty()
	var tmp = _do_line_raycast(current_position, current_position+(new_dir*distance), GlobalSettings.COL_LAYER.WORLD)
	while isRaycastIntersected:
		new_dir = current_direction.rotated(offset)
		isRaycastIntersected = !_do_line_raycast(current_position, current_position+(new_dir*distance), GlobalSettings.COL_LAYER.WORLD).is_empty()
		if isRaycastIntersected:
			new_dir = current_direction.rotated(-offset)
			isRaycastIntersected = !_do_line_raycast(current_position, current_position+(new_dir*distance), GlobalSettings.COL_LAYER.WORLD).is_empty()
			if isRaycastIntersected:
				offset *= 2
	return new_dir


func _collision_avoidance_bounce(current_position, current_direction, new_distance, new_degree_offset = 36):
	var distance = new_distance * GlobalSettings.UNIT
	var new_dir: Vector2 = current_direction
	var offset: float = deg_to_rad(new_degree_offset)
	var raycast = _do_line_raycast(current_position, current_position+(new_dir*distance), GlobalSettings.COL_LAYER.WORLD)
#	_visual_debugger.debug_draw_line(current_position, current_position+(new_dir*distance), Color(1,0,0), 10.0)
	var isRaycastIntersected: bool = !raycast.is_empty()
	if !isRaycastIntersected:
		return current_direction
	else:
		var angle: float = current_direction.angle_to(raycast.normal)
		new_dir = (-current_direction).rotated(2 * angle)
		return new_dir

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func _do_line_raycast(from: Vector2, to: Vector2, col_mask = 0xFFFFFFFF):
	var ray_query := PhysicsRayQueryParameters2D.create(from, to, col_mask)
	var raycast = get_world_2d().direct_space_state.intersect_ray(ray_query)
	return raycast

#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------
func move_army(direction_vector: Vector2):
	var dir: Vector2 = direction_vector
	dir = _collision_avoidance_bounce(_army_position, dir.normalized(), 1)
	_army_velocity = dir * army_speed
	_move()


func move_to_target(target: Vector2 = Vector2.ZERO) -> Vector2:
	return _army_position.direction_to(target)


func wander() -> Vector2:
	if _army_velocity == Vector2.ZERO:
		_army_velocity = Vector2(randf(),randf())
	var wander_offset: float = 1000.0   * GlobalSettings.UNIT
	var wander_radius: float = 500.0  * GlobalSettings.UNIT
	var wander_theta_max_offset: float = 5
	var vel: Vector2 = _army_velocity
	vel = SteeringBehaviour.wander(
		_army_position,
		_army_velocity,
		wander_offset,
		wander_radius,
		wander_theta_max_offset
		)
	return vel

#---------------------------------------------------------------------------------------------------#
# Debug
#---------------------------------------------------------------------------------------------------#
func _debug():
#	_visual_debugger.debug_draw_dot(_army_position)
	pass

@onready var global_pos = global_position#get_global_position()
var local_pos = get_position()


