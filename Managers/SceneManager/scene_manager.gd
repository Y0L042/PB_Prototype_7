extends Node



#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
@onready var _tree_root = get_tree().get_root()


var _root_manager : set = set_root_manager
var _prev_root_manager
var _switched_scene_packed

#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Signals
#-------------------------------------------------------------------------------
signal SwitchRootManagerComplete

signal SwitchRootManager
signal SwitchToGameManager

signal SpawnScene
signal DespawnScene
signal SwitchScene

func _set_signals():
	self.SwitchRootManager.connect(_switch_root_manager)
	self.SwitchToGameManager.connect(_switch_to_GameManager)

	self.SpawnScene.connect(spawn_scene)
	self.DespawnScene.connect(despawn_scene)
	self.SwitchScene.connect(switch_scene)
#-------------------------------------------------------------------------------
# Others
#-------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_root_manager(new_root_manager):
	_prev_root_manager = _root_manager
	_root_manager = new_root_manager
	SwitchRootManagerComplete.emit()


#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _init() -> void:
	add_to_group(SceneLib.Root_Manager_Group)
	_set_signals()

func _ready() -> void:
	_fetch_starting_root_manager()





#-------------------------------------------------------------------------------
# Spawn Managers
#-------------------------------------------------------------------------------
func _switch_to_GameManager(new_mission_setup_data: MissionSetupData):
	var game_manager = _spawn_root_manager(SceneLib.GameManager)
	game_manager.set_mission_setup_data(new_mission_setup_data)
	_despawn_prev_root_manager()


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
	return _root_manager


#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Scene Functions
#-------------------------------------------------------------------------------
func switch_scene(new_scene, old_scene):
	_switched_scene_packed = _pack_node(old_scene)
	despawn_scene(old_scene)
	spawn_scene(new_scene)


func spawn_scene(new_scene):
	SceneLib.spawn_child(new_scene, _root_manager)

func despawn_scene(old_scene):
	old_scene.queue_free()


#---------------------------------------------------------------------------------------------------#
# Tools
#---------------------------------------------------------------------------------------------------#
func _pack_node(new_node):
	var packed_node = SceneLib.pack_node(new_node)
	return packed_node
