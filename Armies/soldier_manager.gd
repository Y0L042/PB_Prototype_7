#extends Resource
#extends RefCounted
extends Node2D

class_name SoldierManager


#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var _parent

signal ArmyIsDefeated
#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
@export_category("Soldier Spawning")
## The initial troop of soldiers that will be spawned
@export var soldier_troop: Resource : set = set_soldier_troop

var all_soldiers_scenes: Array = []
var all_soldiers_array: Array = []
var active_soldiers_array: Array = []
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_parent(new_parent):
	_parent = new_parent
#	owner = _parent#only valid for extends Node
	_parent.ready.connect(_custom_ready)
	_parent.get_tree().physics_frame.connect(_custom_physics_process)

func set_soldier_troop(new_troop):
	soldier_troop = new_troop
	if _parent != null:
		use_troop()
#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _custom_ready(): #resource doesn't have ready, process, so we hijack parent's
	print("soldier manager is ready to spawn your soldiers: ", _parent)
#	if soldier_troop != null:
#		use_troop()


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
	if active_soldiers_array.is_empty() and !all_soldiers_scenes.is_empty():
		ArmyIsDefeated.emit(get_all_soldiers_scenes(), _parent)
		if _parent.enemy_army != null:
			var enemy_army = _parent.enemy_army
			if enemy_army.has_method("receive_necromanced_army"):
				enemy_army.receive_necromanced_army(get_all_soldiers_scenes())
		_parent.queue_free()
		print(self, "  is ded")
		self.queue_free()
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
	return all_soldiers_scenes

func necromance_army(new_soldier_scenes):
	spawn_soldier_array(new_soldier_scenes)
	print(self, "   is necromancing army")
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

	var spawn_pos: Vector2 = _parent._calc_soldier_array_center(active_soldiers_array)
	if is_nan(spawn_pos.x) or is_nan(spawn_pos.y) or spawn_pos == null or spawn_pos == Vector2.ZERO:
		spawn_pos = _parent.get_army_position()

	var soldier = SceneLib.spawn_child(new_soldier, _parent, spawn_pos)#_parent.get_army_position())
	soldier.init(_parent.blackboard)
	all_soldiers_scenes.append(soldier.SCENE)
	all_soldiers_array.append(soldier)
	active_soldiers_array.append(soldier)
	print("soldier spawned: ", soldier)
	if auto_register_soldier:
		_parent.blackboard.register_soldier(soldier)

	connect_to_signals(soldier)
	update_hud()

	return soldier

func connect_to_signals(new_soldier):
	new_soldier.SoldierIsDead.connect(soldier_is_dead)



func add_soldier_weapon_resources():
	pass

func register_soldier_array():
	_parent.blackboard.register_soldier_array(active_soldiers_array)
#---------------------------------------------------------------------------------------------------#
# Events
#---------------------------------------------------------------------------------------------------#
func soldier_is_dead():
	update_hud()

func update_hud():
	if _parent.faction == "Player":
		HudStats.UpdateSoldierCount.emit(active_soldiers_array.size())

























