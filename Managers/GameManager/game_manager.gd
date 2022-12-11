extends Node2D

var mission_setup_data = MissionSetupData.new() : set = set_mission_setup_data, get = get_mission_setup_data


func set_mission_setup_data(new_mission_setup_data: MissionSetupData):
	mission_setup_data = new_mission_setup_data
func get_mission_setup_data():
	return mission_setup_data

func _init() -> void:
	add_to_group(SceneLib.Root_Manager_Group)





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
