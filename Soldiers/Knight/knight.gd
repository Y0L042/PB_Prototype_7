extends BaseSoldier



#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var SCENE = SceneLib.SOLDIER_KNIGHT
var _col_activated: bool = false

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
# Movement Functions
#-------------------------------------------------------------------------------

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

func activate_collision():
	if !_col_activated:
		animation_player.play("FriendlyCollisionExpand")
		_col_activated = true
		print("col ON")
	else: print("already active")
func deactivate_collision():
	if _col_activated:
		animation_player.play_backwards("FriendlyCollisionExpand")
		_col_activated = false
		print("col OFF")
	else: print("already not active")
#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
