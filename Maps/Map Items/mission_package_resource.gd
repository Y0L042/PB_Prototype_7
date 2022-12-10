extends Resource

class_name  MissionPackageRes

@export var meta_data: Resource : set = set_meta_data, get = get_meta_data
@export var mission_stats: Resource : set = set_mission_stats, get = get_mission_stats
@export var mission_achievements: Resource : set = set_mission_achievements, get = get_mission_achievements
@export var mission_unlocks: Resource : set = set_mission_unlocks, get = get_mission_unlocks
@export var mission_scene: PackedScene : set = set_mission_scene, get = get_mission_scene

func set_meta_data(new_meta_data):
	meta_data = new_meta_data
func get_meta_data():
	return meta_data

func set_mission_stats(new_mission_stats):
	mission_stats = new_mission_stats
func get_mission_stats():
	return mission_stats

func set_mission_achievements(new_mission_achievements):
	mission_achievements = new_mission_achievements
func get_mission_achievements():
	return mission_achievements

func set_mission_unlocks(new_mission_unlocks):
	mission_unlocks = new_mission_unlocks
func get_mission_unlocks():
	return mission_unlocks

func set_mission_scene(new_mission_scene):
	mission_scene = new_mission_scene
func get_mission_scene():
	return mission_scene
