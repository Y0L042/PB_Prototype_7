extends Node

class_name MissionSetupData

var map_package_res: Resource : set = set_map_package_res, get = get_map_package_res

func set_map_package_res(new_map_package_res: Resource):
	map_package_res = new_map_package_res
func get_map_package_res():
	return map_package_res
