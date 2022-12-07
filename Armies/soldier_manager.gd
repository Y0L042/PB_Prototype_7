#extends Resource
extends RefCounted

class_name SoldierManager


#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var _parent


#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
@export_category("Soldier Spawning")
## The initial troop of soldiers that will be spawned
@export var soldier_troop: Resource : set = set_soldier_troop


var all_soldiers_array: Array = []
var active_soldiers_array: Array = []
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_parent(new_parent):
	_parent = new_parent
	_parent.ready.connect(_custom_ready)
	_parent.get_tree().physics_frame.connect(_custom_physics_process)

func set_soldier_troop(new_troop):
	soldier_troop = new_troop
#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _custom_ready(): #resource doesn't have ready, process, so we hijack parent's
	print("soldier manager is ready to spawn your soldiers: ", _parent)
	if soldier_troop != null:
		use_troop()


func use_troop():
	var troop_scenes = soldier_troop.get_troop()
	spawn_soldier_array(troop_scenes)
#	for scene in troop:
#		var new_soldier = spawn_soldier(scene)
#	register_soldier_array()
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _custom_physics_process():
#	print("soldier manager physics process.")
	pass
#-------------------------------------------------------------------------------
# Formation Functions
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Other Functions
#-------------------------------------------------------------------------------
func get_all_soldiers_scenes():
	var scenes_array: Array = []
	for soldier in all_soldiers_array:
		scenes_array.append(soldier.SCENE)
	return scenes_array
#-------------------------------------------------------------------------------
# Spawning Functions
#-------------------------------------------------------------------------------
func spawn_soldier_array(array_of_soldier_scenes: Array):
	var spawned_soldiers: Array = []
	for scene in array_of_soldier_scenes:
		var new_soldier = spawn_soldier(scene, false)
		spawned_soldiers.append(new_soldier)
	register_soldier_array()
	return spawned_soldiers

func spawn_soldier(new_soldier, auto_register_soldier = true):
	var soldier = SceneLib.spawn_child(new_soldier, _parent, _parent.get_army_position())
	soldier.init(_parent.blackboard)
	all_soldiers_array.append(soldier)
	active_soldiers_array.append(soldier)
	print("soldier spawned: ", soldier)
	if auto_register_soldier:
		_parent.blackboard.register_soldier(soldier)
	return soldier

func add_soldier_weapon_resources():
	pass

func register_soldier_array():
	_parent.blackboard.register_soldier_array(active_soldiers_array)
#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#


























