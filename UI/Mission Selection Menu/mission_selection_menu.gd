extends Control

var mission_button = preload("res://UI/Mission Selection Menu/Mission Button/mission_button.tscn")
var mission_details_panel = preload("res://UI/Mission Selection Menu/Mission Details Panel/mission_details_panel.tscn")

@onready var btn_back = %"Back Button"
@onready var dynamic_missions_ref_node = %"Levels Grid"
@onready var mission_details_panel_ref_node = %HBoxContainer

var active_mission_details_panel = null

func _ready() -> void:
	btn_back.pressed.connect(_on_back_button_pressed)
	_generate_mission_button_list()


func _on_back_button_pressed() -> void:
	SceneManager.SwitchScene.emit(SceneLib.MAIN_MENU, self)

func _generate_mission_button_list():
	for mission_package in SceneLib.MISSION_LIST:
		var mission_btn = SceneLib.spawn_child(mission_button, dynamic_missions_ref_node)
		mission_btn.CustomPressed.connect(_mission_btn_pressed)
		mission_btn.set_mission_package_res(mission_package)

func _mission_btn_pressed(new_mission_package_res: Resource):
	if active_mission_details_panel != null:
		SceneManager.DespawnScene.emit(active_mission_details_panel)
	active_mission_details_panel = SceneLib.spawn_child(mission_details_panel, mission_details_panel_ref_node)
	active_mission_details_panel.set_mission_package_res(new_mission_package_res)


