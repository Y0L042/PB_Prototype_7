extends Resource

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
@export var soldier_troop: Resource


var all_soldiers_array: Array = []
var living_soldiers_array: Array = []
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_parent(new_parent):
	_parent = new_parent
#	await  _parent.ready
	_parent.ready.connect(_custom_ready)
	_parent.get_tree().physics_frame.connect(_custom_physics_process)

#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _custom_ready(): #resource doesn't have ready, process, so we hijack parent's
	print("soldier manager is ready to spawn your soldiers.")
	use_troop()

func use_troop():
	var troop = soldier_troop.get_troop()
	for scene in troop:
		var soldier = SceneLib.spawn_child(scene, _parent)
		all_soldiers_array.append(soldier)
	living_soldiers_array = all_soldiers_array.duplicate()
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _custom_physics_process():
#	print("soldier manager physics process.")
	pass
#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Spawning Functions
#-------------------------------------------------------------------------------
func spawn_soldier_array(array_of_soldiers: Array):
	for soldier in array_of_soldiers:
		spawn_soldier(soldier)

func spawn_soldier(new_soldier):
	SceneLib.spawn_child(new_soldier.SCENE, _parent)

func add_soldier_weapon_resources():
	pass

#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#


























