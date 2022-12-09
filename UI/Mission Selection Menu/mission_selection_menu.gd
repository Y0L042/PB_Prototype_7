extends Control

@onready var btn_back = %"Back Button"

func _ready() -> void:
	btn_back.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed() -> void:
	SceneManager.

