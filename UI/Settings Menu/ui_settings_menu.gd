extends Control


@onready var btn_back = %Back

func _ready() -> void:
	btn_back.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed() -> void:
	SceneManager.SwitchScene.emit(SceneLib.MAIN_MENU, self)
