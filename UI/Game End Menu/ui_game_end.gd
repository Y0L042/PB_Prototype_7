extends Control

@onready var canvas_layer = $CanvasLayer
@onready var condition_label: Label = %Condition

@export var _visible: bool = false : set = _set_visible

func _set_visible(isVisible: bool):
	_visible = isVisible
	canvas_layer.set_visible(_visible)

func _pause_game():
	get_tree().paused = true
func _unpause_game():
	get_tree().paused = false


func _ready() -> void:
	get_parent().GameOver.connect(activate_game_over)
	_visible = false

func activate_game_over():
	_pause_game()
	_visible = true

func deactivate_game_over():
	_unpause_game()
	_visible = false

func _on_restart_pressed() -> void:
	get_tree().paused = false
	SceneManager._root_manager.restart_mission()
	deactivate_game_over()



func _on_main_menu_pressed() -> void:
	SceneManager._switch_root_manager(SceneLib.MainMenuManager)
