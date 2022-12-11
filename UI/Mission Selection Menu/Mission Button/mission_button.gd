extends Button

signal CustomPressed

var btn_mission = self
@onready var parent = get_parent()

@export var mission_package_res: Resource : set = set_mission_package_res
@export var mission_name: String : set = set_mission_name

func set_mission_package_res(new_mission_package_res):
	mission_package_res = new_mission_package_res
	setup()

func set_mission_name(new_name: String):
	mission_name = new_name
	btn_mission.set_text(mission_name)

func setup():
	mission_name = mission_package_res.meta_data.mission_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_emit_custom_pressed)
#	grab_focus()

func _emit_custom_pressed():
	CustomPressed.emit(mission_package_res)



