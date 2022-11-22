extends Node

#-------------------------------------------------------------------------------
# Actor Scenes
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Weapons
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Maps
#-------------------------------------------------------------------------------
var MAP_1: PackedScene = load("res://Maps/Map 1/map_1.tscn")


#-------------------------------------------------------------------------------
# UI
#-------------------------------------------------------------------------------
var SCENE_MAIN_MENU: PackedScene = load("res://Main/main.tscn")

var UI_MAIN_MENU: PackedScene = load("res://UI/Main Menu/ui_main_menu.tscn")
var UI_PAUSE_MENU: PackedScene = load("res://UI/Pause Menu/ui_pause_menu.tscn")
var UI_GAME_END: PackedScene = load("res://UI/Game End Menu/ui_game_end.tscn")

#-------------------------------------------------------------------------------
# Scene Tools
#-------------------------------------------------------------------------------
func spawn_child(child: PackedScene, parent, _new_global_position: Vector2 = Vector2.ZERO):
	var child_instance = child.instantiate()
	parent.add_child(child_instance)
	child_instance.set_global_position(Vector2.ZERO)
	return child_instance


func return_random_scene(new_array: Array):
	var rand_index = randi_range(0, new_array.size() - 1)
	return new_array[rand_index]


func change_scene():
	pass

var CONTINUE_GAME: bool
func save_game():
	print("TBI - Save Game")
func load_game():
	print("TBI = Load Game")













