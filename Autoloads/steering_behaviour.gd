extends Node

#-------------------------------------------------------------------------------
# Private Variables
#-------------------------------------------------------------------------------
const DEFAULT_WEIGHT: float = 0.5

#-------------------------------------------------------------------------------
# Steering Functions
#-------------------------------------------------------------------------------
func seek(current_pos: Vector2, seek_target: Vector2, weight: float = DEFAULT_WEIGHT):
	var vel: Vector2 = current_pos.direction_to(seek_target) * weight
	return vel # normalized, weighted

func wander(current_pos: Vector2, current_vel: Vector2 = Vector2.ZERO, weight: float = DEFAULT_WEIGHT):
	var wander_offset: float = 750.0
	var wander_radius: float = 50000.0
	var wander_theta_max_offset: float = 15
	var wander_pos: Vector2 = current_pos + (current_vel.normalized() * wander_offset)
	var theta: float = 0 # zero ref is E, Clockwise
	theta += randf_range(-wander_theta_max_offset, wander_theta_max_offset)
	theta = deg_to_rad(theta) + current_vel.angle() # makes theta relative to vehicle direction
	var x: float = wander_radius * cos(theta)
	var y: float = wander_radius * sin(theta)
	var wander_target: Vector2 = wander_pos + Vector2(x, y)
	var vel: Vector2 = seek(current_pos, wander_target, weight)
	return vel # normalized, weighted

