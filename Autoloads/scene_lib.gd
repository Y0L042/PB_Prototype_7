extends Node


#---------------------------------------------------------------------------------------------------#
# Managers
#---------------------------------------------------------------------------------------------------#
@export var Root_Manager_Group: String = "Root_Manager"
var MainMenuManager: PackedScene = load("res://Managers/MainMenuManager/main_menu_manager.tscn")
var GameManager: PackedScene = load("res://Managers/GameManager/game_manager.tscn")

#---------------------------------------------------------------------------------------------------#
# Layers
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Collision
#-------------------------------------------------------------------------------
# all layers up to 10 (0b1010) is reserved
var PLAYER_COL_LAYER: int = 0b1011
var ENEMY_1_COL_LAYER: int = 0b1100

#---------------------------------------------------------------------------------------------------#
# Armies
#---------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------
# Army Scenes
#-------------------------------------------------------------------------------
var PLAYER_ARMY: PackedScene = load("res://Armies/PlayerArmy/player_army.tscn")

var ENEMY_ARMY: PackedScene = load("res://Armies/EnemyArmy/enemy_army.tscn")
var WANDER_AI: Resource = load("res://Armies/EnemyArmy/AI/Wander/wander.tres")
#-------------------------------------------------------------------------------
# Soldiers
#-------------------------------------------------------------------------------
var SOLDIER_KNIGHT: PackedScene = load("res://Soldiers/Knight/knight.tscn")

#-------------------------------------------------------------------------------
# Weapons
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Maps
#-------------------------------------------------------------------------------
var Map_Item_Group: String = "MAP_ITEM"

var MAP_0_PACKAGE_RES: Resource = load("res://Maps/Map 0/map_0_package.tres")
var MAP_0: PackedScene = load("res://Maps/Map 0/map_0.tscn")

var MAP_1_PACKAGE_RES: Resource = load("res://Maps/Map 1/map_1_package.tres")
var MAP_1: PackedScene = load("res://Maps/Map 1/map_1.tscn")

var MISSION_LIST: Array[Resource] = [
	MAP_0_PACKAGE_RES,
	MAP_1_PACKAGE_RES
]

#-------------------------------------------------------------------------------
# FX
#-------------------------------------------------------------------------------
#Blood Splatters
var fx_sprite_blood_splatter_1: PackedScene = load("res://Fx/Sprites/Blood Splatters/Blood Splatter 1/blood_1.tscn")
#-------------------------------------------------------------------------------
# UI
#-------------------------------------------------------------------------------
#var SCENE_MAIN_MENU: PackedScene = load("res://Main/main.tscn")

#var UI_MAIN_MENU: PackedScene = load("res://UI/Main Menu/ui_main_menu.tscn")

var MAIN_MENU: PackedScene = load("res://UI/Main Menu/main_menu.tscn")

var MISSION_SELECT: PackedScene = load("res://UI/Mission Selection Menu/mission_selection_menu.tscn")

var SETTINGS_MENU: PackedScene = load("res://UI/Settings Menu/ui_settings_menu.tscn")

var UI_PAUSE_MENU: PackedScene = load("res://UI/Pause Menu/ui_pause_menu.tscn")
var UI_GAME_END: PackedScene = load("res://UI/Game End Menu/ui_game_end.tscn")

var UI_HUD: PackedScene = load("res://UI/HUD/hud.tscn")
#-------------------------------------------------------------------------------
# Scene Tools
#-------------------------------------------------------------------------------
func spawn_child(child: PackedScene, parent, _new_global_position: Vector2 = Vector2.ZERO):
	var child_instance = child.instantiate()
	parent.add_child(child_instance)
	child_instance.set_global_position(_new_global_position)
	return child_instance

func pack_node(new_node):
	var scene = PackedScene.new()
	scene.pack(new_node)
	return scene

#TODO:

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













