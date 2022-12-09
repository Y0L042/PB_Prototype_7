extends Node



#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
@onready var _tree_root = get_tree().get_root()


var _root_manager : set = set_root_manager
var _prev_root_manager

#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#

#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_root_manager(new_root_manager):
	_prev_root_manager = _root_manager
	_root_manager = new_root_manager

#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _init() -> void:
	add_to_group(SceneLib.Root_Manager_Group)

func _ready() -> void:
	_fetch_starting_root_manager()

#	call_deferred("_spawn_root_manager", SceneLib.MainMenuManager)
#	await get_tree().create_timer(3).timeout




#-------------------------------------------------------------------------------
# Spawn Managers
#-------------------------------------------------------------------------------
func _switch_root_manager(new_manager):
	_spawn_root_manager(new_manager)
	_despawn_prev_root_manager()


func _fetch_starting_root_manager():
	for child in get_tree().get_root().get_children():
		if child.is_in_group(SceneLib.Root_Manager_Group) and child != self:
			_root_manager = child
			return


func _despawn_root_manager():
	_root_manager.queue_free()


func _despawn_prev_root_manager():
	_prev_root_manager.queue_free()


func _spawn_root_manager(new_manager):
	_root_manager = SceneLib.spawn_child(new_manager, _tree_root)


#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func spawn_scene(new_scene):
	SceneLib.spawn_child(new_scene, _root_manager)

#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
