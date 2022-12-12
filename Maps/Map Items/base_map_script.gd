extends Node2D

class_name  BaseMap


signal MissionSetupDataReceived

var mission_setup_data: MissionSetupData : set = set_mission_setup_data, get = get_mission_setup_data


func set_mission_setup_data(new_mission_setup_data: MissionSetupData):
	mission_setup_data = new_mission_setup_data
	MissionSetupDataReceived.emit()
func get_mission_setup_data():
	return mission_setup_data

func _init() -> void:
	MissionSetupDataReceived.connect(_set_up_map)

func _set_up_map():
	# do map setup things, set variables, etc.
	# after map variables has been set up, start map items
	get_tree().call_group(SceneLib.Map_Item_Group, "start_map_item")
