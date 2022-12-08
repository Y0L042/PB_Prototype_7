extends Control

@onready var btn_back = %"Back Button"

func _ready() -> void:
	btn_back.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed() -> void:
	SceneLib.spawn_child(SceneLib.MAIN_MENU, get_parent())
	self.queue_free()

