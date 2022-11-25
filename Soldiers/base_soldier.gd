extends CharacterBody2D

class_name BaseSoldier


#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
@export @onready var _ai_module: Resource : set = set_ai_module


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
@onready var soldier_sight: Area2D = %Sight

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

func set_ai_module(new_ai_module):
	if new_ai_module == null:
		print("Error: AI module scene is empty!")
		return -1
	_ai_module = new_ai_module
#	_ai_module.set_local_to_scene(true)
	_ai_module.set_parent(self)
#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
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
	_custom_process(delta)

func _ai_module_process(_delta: float):
	# Run AI Module _physics
	if _ai_module != null:
		_ai_module.ai_module_physics_process(_delta)

func _custom_process(_delta: float):
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

#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
