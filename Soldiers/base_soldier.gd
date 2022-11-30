extends CharacterBody2D

class_name BaseSoldier


#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
signal CustomReady
@export @onready var _ai_module: Resource : set = set_ai_module
var _parent
var _formation_index: int


#-------------------------------------------------------------------------------
# Blackboard Variables
#-------------------------------------------------------------------------------
var _faction
var _army
var _army_id
var _formation
var _faction_colour
var _move_order

#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# "Features"
#-------------------------------------------------------------------------------
@onready var soldier_collision_shape: CollisionShape2D = %SoldierCollision
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_tree_mode = animation_tree["parameters/playback"]
@onready var pivot: Marker2D = %Pivot
@onready var body_sprite: Sprite2D = %BodySprite
@onready var weapon_pivot: Marker2D = %WeaponPivot
@onready var sight: Area2D = %Sight
@onready var force_area: Area2D = %ForceArea

var blackboard: Dictionary : set = set_blackboard
#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export_category("Arrays of Resources")
@export var array_of_stats: Array = []
@export var array_of_effects: Array = []
@export var array_of_weapons: Array = []
@export var array_of_weapon_effects: Array = [] #? here or in Weapon??

#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_blackboard(new_blackboard):
	blackboard = new_blackboard
	_faction = blackboard.faction
	_army = blackboard.army
	_army_id = blackboard.army_id
	_faction_colour = blackboard.faction_colour
	_formation = blackboard.formation



func set_ai_module(new_ai_module):
	if new_ai_module == null:
#		print("Error: AI module scene is empty! : ", self)
		return -1
	_ai_module = new_ai_module
	_ai_module.set_parent(self)

func get_attack_range():
	return 1.5 * GlobalSettings.UNIT
#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func init(new_blackboard) -> void:
	blackboard = new_blackboard
	CustomReady.emit(blackboard)
	return self

func _ready() -> void:
	_ai_module_ready()

func _ai_module_ready():
	# Run AI Module _ready
	if _ai_module != null:
		_ai_module.ai_module_ready()
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	_ai_module_process(delta)
	_base_process(delta)
	_custom_process(delta)

func _base_process(_delta: float):
	_formation_index = get_position_in_formation()

func _ai_module_process(_delta: float):
	# Run AI Module _physics
	if _ai_module != null:
		_ai_module.ai_module_physics_process(_delta)

func _custom_process(_delta: float):
	pass # leave empty for subclasses


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
# Actions
#-------------------------------------------------------------------------------
func attack(enemy):
	pass
#-------------------------------------------------------------------------------
# Formation Functions
#-------------------------------------------------------------------------------
func get_position_in_formation():
	var index: int = -1
#	for soldier_index in blackboard.active_soldiers.size():
#		if self.get_instance_id() == blackboard.active_soldiers[soldier_index].get_instance_id():
#			index = soldier_index
#			break
	index = blackboard.active_soldiers.find(self)
	return index
#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
