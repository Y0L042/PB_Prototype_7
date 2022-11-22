extends Army

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#



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
# Runtime
#-------------------------------------------------------------------------------
func _custom_process(delta: float):
	_move_army()
	_draw_debug()



#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------
func _move_army():
	var dir: Vector2 = _army_velocity
	dir = wander()
	dir = _collision_avoidance_adjuster(_army_position, _army_position + (dir * army_speed * _delta))
	_army_velocity = dir * army_speed
	_move()


func _move_to_target(target: Vector2 = Vector2.ZERO) -> Vector2:
	return _army_position.direction_to(target)

func wander() -> Vector2:
	if _army_velocity == Vector2.ZERO:
		_army_velocity = Vector2(1,1)
	var vel: Vector2 = _army_velocity
	vel = SteeringBehaviour.wander(_army_position, _army_velocity)
	return vel

func _collision_avoidance_adjuster(self_pos, target_pos):
	var new_dir: Vector2
	var offset: float = deg_to_rad(36)
	var isRaycastIntersected: bool = !_do_line_raycast(self_pos, target_pos, GlobalSettings.COL_LAYER.WORLD).is_empty()
	while isRaycastIntersected:
		print("intersected_1")
		new_dir = (target_pos - self_pos).rotated(offset)
		target_pos = new_dir + self_pos
		isRaycastIntersected = !_do_line_raycast(self_pos, target_pos, GlobalSettings.COL_LAYER.WORLD).is_empty()
		if isRaycastIntersected:
			print("intersected__2")
			new_dir = (target_pos - self_pos).rotated(-offset)
			target_pos = new_dir + self_pos
			isRaycastIntersected = !_do_line_raycast(self_pos, target_pos, GlobalSettings.COL_LAYER.WORLD).is_empty()
			if isRaycastIntersected:
				print("intersected___3")
				offset *= 2
	return self_pos.direction_to(target_pos)
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

#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
func _draw_debug():
	queue_redraw()

func _draw() -> void: #%Debug
	_debug_draw_army_formation()
	_debug_draw_army_position(get_army_position())
	_debug_draw_army_velocity(get_army_position(), _army_velocity)

func _debug_draw_army_formation():
	var col = Color(0, 0, 1)
	var rad = int(GlobalSettings.UNIT/2)
	for spot in _formation.vector_array:
		draw_circle(spot, rad, col)

func _debug_draw_army_position(new_pos):
	var col = Color(0, 0, 1)
	var rad = int(GlobalSettings.UNIT/2)
	draw_circle(new_pos, rad, col)

func _debug_draw_army_velocity(start, end):
	var col = Color(0, 1, 1)
	var width = 0.1
	end += start
	draw_line(start, end, col, width)
