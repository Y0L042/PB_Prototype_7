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
	SceneLib.spawn_child(SceneLib.MISSION_SELECT, get_parent())
	self.queue_free()

func spawn_settings_menu():
	SceneLib.spawn_child(SceneLib.SETTINGS_MENU, get_parent())
	self.queue_free()
