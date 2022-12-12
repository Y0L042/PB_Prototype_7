extends Control

var isPaused: bool = false


@onready var canvas_layer = %CanvasLayer

@onready var btn_Resume := %Resume
@onready var btn_MainMenu := %MainMenu
@onready var btn_Quit := %Quit

@export var _visible: bool = false : set = _set_visible

func _set_visible(isVisible: bool):
	_visible = isVisible
	canvas_layer.set_visible(_visible)

func _ready() -> void:
	_visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if !isPaused:
			print("pause")
			pause()




func _on_main_menu_pressed() -> void:
	SceneManager._switch_root_manager(SceneLib.MainMenuManager)


func _on_resume_pressed() -> void:
	unpause()

func _on_quit_pressed() -> void:
	quit()




func pause():
	canvas_layer.set_visible(true)
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	btn_Resume.grab_focus()

func unpause():
	canvas_layer.set_visible(false)
	get_tree().paused = false
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) disabled for debugging because it is annoying

func quit():
	get_tree().quit()

