extends BaseSoldierAIModule

class_name StandardSoldierAIModule

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
# Initialization
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func ai_module_ready():
	print("Soldier ready")

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func ai_module_physics_process(_delta: float):
	var target: Vector2
	if _parent._formation_index == -1:
		target = _parent._formation.center_position
	else:
		target = _parent._formation.vector_array[_parent._formation_index]
	var direction: Vector2 = _parent.get_global_position().direction_to(target)

	var dist_check: int = int(_parent.get_global_position().distance_squared_to(target) > 10*10)
	var army_move_check: int = int(_parent._army._army_velocity.length() > 5)
	_parent.velocity = direction * GlobalSettings.UNIT * 4.75 * int(dist_check||army_move_check)
	_parent.move_and_slide()
#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
