extends Control


@onready var lbl_mission_name = %"Mission Name"
@onready var lbl_mission_description = %"Mission Description"

@export var mission_package_res: Resource : set = set_mission_package_res

func set_mission_package_res(new_mission_package_res):
	mission_package_res = new_mission_package_res
	setup()




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup():
	lbl_mission_name.set_text(mission_package_res.meta_data.mission_name)
	lbl_mission_description.set_text(mission_package_res.meta_data.mission_description)
