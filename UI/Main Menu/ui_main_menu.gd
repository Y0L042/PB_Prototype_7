extends Control

#-------------------------------------------------------------------------------
# Signals
#-------------------------------------------------------------------------------
signal startNewGame
signal continueGame

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
@onready var btn_ContinueGame = %ContinueGame
@onready var btn_StartNewGame = %StartNewGame
@onready var btn_Quit = %Quit




#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _on_start_new_game_pressed() -> void:
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) disabled for debugging because it is annoying
	startNewGame.emit(self)
	get_tree().change_scene_to_packed(SceneLib.MAP_1)

func _on_quit_pressed() -> void:
	quit()

func _on_continue_game_pressed() -> void:
	continueGame.emit(self)





func quit():
	get_tree().quit()

func keep_pause_disabled():
	pass

