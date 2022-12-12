extends Node2D

signal MissionSetupDataReceived
signal GameOver

var mission_setup_data: MissionSetupData : set = set_mission_setup_data, get = get_mission_setup_data
var current_map

func set_mission_setup_data(new_mission_setup_data: MissionSetupData):
	mission_setup_data = new_mission_setup_data
	MissionSetupDataReceived.emit()
func get_mission_setup_data():
	return mission_setup_data

func _init() -> void:
	add_to_group(SceneLib.Root_Manager_Group)
	connect_signals()

func connect_signals():
	pass


func _ready() -> void:
	await  MissionSetupDataReceived
	_spawn_map()
	_spawn_ui_elements()

func _spawn_map():
	current_map = SceneLib.spawn_child(mission_setup_data.get_mission_package_res().get_mission_scene(), self)
	current_map.set_mission_setup_data(mission_setup_data)

func restart_mission():
	current_map.queue_free()
	await get_tree().create_timer(1).timeout
	_spawn_map()

func _spawn_ui_elements():
	SceneLib.spawn_child(SceneLib.UI_PAUSE_MENU, self)
	SceneLib.spawn_child(SceneLib.UI_HUD, self)
	SceneLib.spawn_child(SceneLib.UI_GAME_END, self)
