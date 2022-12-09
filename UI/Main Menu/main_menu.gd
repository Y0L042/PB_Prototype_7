extends Control


signal StartGame
signal SettingsMenu

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
@onready var btn_StartGame = %Start
@onready var btn_Settings = %Settings
@onready var btn_Quit = %Quit





#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_set_signals()


func _set_signals():
	btn_StartGame.pressed.connect(_on_start_game_pressed)
	btn_Quit.pressed.connect(_on_quit_pressed)
	btn_Settings.pressed.connect(_on_settings_pressed)

#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _on_start_game_pressed() -> void:
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) disabled for debugging because it is annoying
	spawn_mission_select()

func _on_settings_pressed():
	spawn_settings_menu()


func _on_quit_pressed() -> void:
	quit()

func quit():
	get_tree().quit()

func keep_pause_disabled():
	pass

#-------------------------------------------------------------------------------
# Spawn Menus
#-------------------------------------------------------------------------------
func spawn_mission_select():
	SceneManager.SwitchScene.emit(SceneLib.MISSION_SELECT, self)

func spawn_settings_menu():
	SceneManager.SwitchScene.emit(SceneLib.SETTINGS_MENU, self)

