extends Area2D



#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
@onready var parent = get_parent()


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
func _physics_process(delta: float) -> void:
	_update_position()
	_update_army_sight_scale()


func _update_position():
	self.set_global_position(parent.get_army_position())

#-------------------------------------------------------------------------------
# Formation Related
#-------------------------------------------------------------------------------
func _update_army_sight_scale():
	var new_scale_vector: Vector2 = Vector2.ZERO
	var width = parent.formation.width
	var height = parent.formation.height
	var pow_factor_x: float = 1/ 1.25
	var pow_factor_y: float = 1/ 1.25
	new_scale_vector.x = pow( width , pow_factor_x )
	new_scale_vector.y = pow( height , pow_factor_y )
	self.set_rotation(parent.formation.rotation)
	self.set_scale(new_scale_vector)



#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#

#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#



