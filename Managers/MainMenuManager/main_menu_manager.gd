extends Control


func _init() -> void:
	add_to_group(SceneLib.Root_Manager_Group)

func _ready() -> void:
	# I used call_deferred, because this node's _ready() would be called before SceneLib.spawn_child()
	# returned the scene_manager's root_manager: spawn_scene would then give an error
	SceneManager.SpawnScene.emit(SceneLib.MAIN_MENU)


