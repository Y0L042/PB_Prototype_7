extends BaseWeapon

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var _enemy


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
func attack_area(coords: Vector2):
	pass

func attack_enemy(new_enemy):
	_enemy = new_enemy
	anim_attack_1()

func do_damage():
	if is_instance_valid(_enemy):
		_enemy.hurt(damage)

func fire_arrow():
	pass
#-------------------------------------------------------------------------------
# Animations
#-------------------------------------------------------------------------------
func anim_attack_1():
	animation_tree_mode.travel("Attack_1")
