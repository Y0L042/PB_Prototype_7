extends Button

var btn_mission = self
@onready var parent = get_parent()

@export var mission_scene: PackedScene
@export var mission_name: String : set = set_mission_name

func set_mission_name(new_name: String):
	mission_name = new_name
	btn_mission.set_text(mission_name)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_mission.pressed.connect(load_mission)
	grab_focus()


func load_mission():
#	parent.queue_free()
	parent.get_tree().change_scene_to_packed(mission_scene)

