extends Node2D



#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
@onready var _player_spawns: Node2D = %"Player Spawns"
@onready var _enemy_spawns: Node2D = %"Enemy Spawns"

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
# Initialize
#-------------------------------------------------------------------------------
func _ready() -> void:
#	randomize()
	seed(11)
#	_spawn_players()
	_spawn_enemies()
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func _spawn_players():
	for child in _player_spawns.get_children():
		var _spawn_point: Vector2 = child.get_global_position()
		var army = SceneLib.spawn_child(SceneLib.PLAYER_ARMY, self)
		army.set_army_position(_spawn_point)

func _spawn_enemies():
	for child in _enemy_spawns.get_children():
		var _spawn_point: Vector2 = child.get_global_position()
		var army = SceneLib.spawn_child(SceneLib.ENEMY_ARMY, self)
		army.set_army_position(_spawn_point)
#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#

#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
