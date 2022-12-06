extends BaseSoldier



#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var SCENE = SceneLib.SOLDIER_KNIGHT
var _col_activated: bool = false

@onready var force_area: Area2D = %SoldierCollision



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
func _custom_ready():
	pass
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _custom_process(_delta: float):
	pass

#-------------------------------------------------------------------------------
# Collision Functions
#-------------------------------------------------------------------------------
func activate_collision():
	if !_col_activated:
#




		_col_activated = true
		print("col ON")
	else: print("already active")

func deactivate_collision():
	if _col_activated:
#


		_col_activated = false
		print("col OFF")
	else: print("already not active")
#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Animation Interface
#-------------------------------------------------------------------------------
func anim_run():
	animation_tree_mode.travel("Jog")

func anim_hurt():
	animation_tree_mode.travel("Hurt")


#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
