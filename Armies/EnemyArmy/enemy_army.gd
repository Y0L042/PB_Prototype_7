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
		print("Error: AI module scene is empty!")
		return -1
	_ai_module = new_ai_module
#	_ai_module.set_local_to_scene(true)
	_ai_module.set_parent(self)

#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	# Run AI Module _ready
	if _ai_module != null:
		_ai_module.ai_module_ready()

	formation.set_volume(9)
	formation.set_width(3)


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _custom_process(delta: float):
	# Run AI Module _physics
	if _ai_module != null:
		_ai_module.ai_module_physics_process(delta)

	_set_formation_rotation()
	_draw_debug()



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
		print("intersected_1")
		new_dir = current_direction.rotated(offset)
		isRaycastIntersected = !_do_line_raycast(current_position, current_position+(new_dir*distance), GlobalSettings.COL_LAYER.WORLD).is_empty()
		if isRaycastIntersected:
			print("intersected__2")
			new_dir = current_direction.rotated(-offset)
			isRaycastIntersected = !_do_line_raycast(current_position, current_position+(new_dir*distance), GlobalSettings.COL_LAYER.WORLD).is_empty()
			if isRaycastIntersected:
				print("intersected___3")
				offset *= 2
	return new_dir


func _collision_avoidance_bounce(current_position, current_direction, new_distance, new_degree_offset = 36):
	var distance = new_distance * GlobalSettings.UNIT
	var new_dir: Vector2 = current_direction
	var offset: float = deg_to_rad(new_degree_offset)
	var raycast = _do_line_raycast(current_position, current_position+(new_dir*distance), GlobalSettings.COL_LAYER.WORLD)
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
# %debug%
#---------------------------------------------------------------------------------------------------#
func _draw_debug():
	queue_redraw()

func _draw() -> void: #%Debug
	_debug_draw_army_rotation()
	_debug_draw_army_position(get_army_position())
	_debug_draw_army_velocity(get_army_position(), _army_velocity)
	_debug_draw_army_formation()

func _debug_draw_army_formation():
	var col = Color(1, 0, 1)
	var rad = int(GlobalSettings.UNIT/2)
	_debug_draw_grid_dots(formation.vector_array, col, rad)

func _debug_draw_army_position(new_pos):
	var col = Color(0, 0, 1)
	var rad = int(GlobalSettings.UNIT/1.75)
	draw_circle(new_pos, rad, col)

func _debug_draw_army_velocity(start, end):
	var col = Color(0, 1, 1)
	var width = 0.1
	end += start
	draw_line(start, end, col, width)

func _debug_draw_army_rotation():
	var start: Vector2 = _army_position
	var end: Vector2 = Vector2.RIGHT.rotated(formation.rotation) * 2 * GlobalSettings.UNIT
	var col = Color(1, 0, 1)
	var width = 100
	_debug_draw_line(start, end, col, width)
