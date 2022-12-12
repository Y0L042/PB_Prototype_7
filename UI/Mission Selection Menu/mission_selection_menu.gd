extends Control



var mission_button = preload("res://UI/Mission Selection Menu/Mission Button/mission_button.tscn")
var mission_details_panel = preload("res://UI/Mission Selection Menu/Mission Details Panel/mission_details_panel.tscn")

@onready var btn_back = %"Back Button"
@onready var btn_next = %"Next Button"

@onready var dynamic_missions_ref_node = %"Levels Grid"
@onready var mission_details_panel_ref_node = %DetailsRef
@onready var _parent = get_parent()

var active_mission_details_panel = null
var selected_mission_package_res = null

var mission_btn_list: Array = []

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
		mission_btn_list.append(mission_btn)
	if !mission_btn_list.is_empty():
		mission_btn_list[0].grab_focus()
	else:
		btn_back.grab_focus()

func _mission_btn_pressed(new_mission_package_res: Resource):
	btn_next.set_disabled(false)
	if active_mission_details_panel != null:
		SceneManager.DespawnScene.emit(active_mission_details_panel)
	active_mission_details_panel = SceneLib.spawn_child(mission_details_panel, mission_details_panel_ref_node)
	active_mission_details_panel.set_mission_package_res(new_mission_package_res)
	selected_mission_package_res = new_mission_package_res
	set_mission_setup_data()

func set_mission_setup_data():
	# how do I know I am getting MainMenuManager, with mission_setup_data? TODO fix it
	if _parent == null: return
	var setup_data = _parent.get_mission_setup_data()
	setup_data.set_mission_package_res(selected_mission_package_res)

func _next():
	# this will load the army customization menu
	# but for now it will simply start the game
	_parent.switch_to_GameManager()
