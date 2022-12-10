extends Control

var mission_button = preload("res://UI/Mission Selection Menu/Mission Button/mission_button.tscn")
var mission_details_panel = preload("res://UI/Mission Selection Menu/Mission Details Panel/mission_details_panel.tscn")

@onready var btn_back = %"Back Button"
@onready var btn_next = %"Next Button"

@onready var dynamic_missions_ref_node = %"Levels Grid"
@onready var mission_details_panel_ref_node = %HBoxContainer

var active_mission_details_panel = null
var selected_mission_package_res = null

func _ready() -> void:
	_connect_to_signals()
	_generate_mission_button_list()

func _connect_to_signals():
	btn_back.pressed.connect(_on_back_button_pressed)
	btn_next.pressed.connect(_next)

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
	selected_mission_package_res = new_mission_package_res

func _next():
	# this will load the army customization menu
	# but for now it will simply start the game
	pass
