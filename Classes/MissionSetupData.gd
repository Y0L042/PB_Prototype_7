extends Node

class_name MissionSetupData

var mission_package_res: Resource : set = set_mission_package_res, get = get_mission_package_res

func set_mission_package_res(new_mission_package_res: Resource):
	mission_package_res = new_mission_package_res
func get_mission_package_res():
	return mission_package_res
