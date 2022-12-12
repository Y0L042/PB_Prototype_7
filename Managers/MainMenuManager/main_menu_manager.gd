extends Control

var mission_setup_data = MissionSetupData.new() : get = get_mission_setup_data


func get_mission_setup_data():
	return mission_setup_data

func _init() -> void:
	add_to_group(SceneLib.Root_Manager_Group)
	SceneManager.SwitchRootManagerComplete.connect(start, CONNECT_ONE_SHOT)

func _ready() -> void:
#	SceneManager.SpawnScene.emit(SceneLib.MAIN_MENU)
	pass

func start():
	SceneManager.SpawnScene.emit(SceneLib.MAIN_MENU)

func switch_to_GameManager():
	SceneManager.SwitchToGameManager.emit(get_mission_setup_data())

