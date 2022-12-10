extends Resource

class_name  MapPackageRes

@export var meta_data: Resource : set = set_meta_data, get = get_meta_data
@export var map_stats: Resource : set = set_map_stats, get = get_map_stats
@export var map_achievements: Resource : set = set_map_achievements, get = get_map_achievements
@export var map_unlocks: Resource : set = set_map_unlocks, get = get_map_unlocks
@export var map_scene: PackedScene : set = set_map_scene, get = get_map_scene

func set_meta_data(new_meta_data):
	meta_data = new_meta_data
func get_meta_data():
	return meta_data

func set_map_stats(new_map_stats):
	map_stats = new_map_stats
func get_map_stats():
	return map_stats

func set_map_achievements(new_map_achievements):
	map_achievements = new_map_achievements
func get_map_achievements():
	return map_achievements

func set_map_unlocks(new_map_unlocks):
	map_unlocks = new_map_unlocks
func get_map_unlocks():
	return map_unlocks

func set_map_scene(new_map_scene):
	map_scene = new_map_scene
func get_map_scene():
	return map_scene
