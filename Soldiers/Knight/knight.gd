#extends BaseSoldier

extends CharacterBody2D

#class_name BaseSoldier


#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
signal CustomReady
@export @onready var _ai_module: Resource : set = set_ai_module
var _parent
var _formation_index: int : set = set_formation_index, get = get_formation_index


#-------------------------------------------------------------------------------
# Blackboard Variables
#-------------------------------------------------------------------------------
var faction
var _army
var _army_id
var _formation
var _faction_colour
var _move_order

#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Stats
#-------------------------------------------------------------------------------
@export var health: float = 5.0 : set = set_health
@export var speed: float = 5.0 : set = set_speed
#-------------------------------------------------------------------------------
# "Features"
#-------------------------------------------------------------------------------
@onready var base_collision_shape: CollisionShape2D = %BaseCollision
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_tree_mode = animation_tree["parameters/playback"]
@onready var pivot: Marker2D = %Pivot
@onready var shadow: Sprite2D = %Shadow
@onready var body_sprite: Sprite2D = %BodySprite
@onready var weapon_pivot: Marker2D = %WeaponPivot
@onready var sight: Area2D = %Sight



var blackboard: ArmyBlackboard : set = set_blackboard
#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export_category("Arrays of Resources")
@export var array_of_stats: Array = []
@export var array_of_effects: Array = []
@onready @export var array_of_weapons: Array = weapon_pivot.get_children() : set = set_array_of_weapons
@export var array_of_weapon_effects: Array = [] #? here or in Weapon??

#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_blackboard(new_blackboard):
	blackboard = new_blackboard
	blackboard.FormationUpdate.connect(_get_index_from_formation)
	faction = blackboard.faction
	_army = blackboard.army
	_army_id = blackboard.army_id
	_faction_colour = blackboard.get_faction_colour()
	_formation = blackboard.formation

	set_faction_stuff()

func set_ai_module(new_ai_module):
	if new_ai_module == null:
#		print("Error: AI module scene is empty! : ", self)
		return -1
	_ai_module = new_ai_module
	_ai_module.set_parent(self)

func set_array_of_weapons(new_array):
	if new_array == null: return
	array_of_weapons = new_array

func get_attack_range():
	var attack_range: float = 1 * GlobalSettings.UNIT#-1.0
	for weapon in array_of_weapons:
		if weapon.range > attack_range:#replace with actual stat
			attack_range = weapon.range#replace with actual stat
	return attack_range

func set_health(new_health):
	if new_health < health:
		anim_hurt()
	health = new_health
	if health <= 0:
		set_dead()

func set_speed(new_speed):
	speed = new_speed

func set_dead():
	SceneLib.spawn_child(load("res://Fx/Sprites/blood_1.tscn"), get_parent(), get_global_position())
	blackboard.active_soldiers.erase(self)
	blackboard.deregister_soldier(self)
	self.queue_free()

func set_faction_stuff():
	set_actor_faction_outline()

func set_actor_faction_outline():
	body_sprite.get_material().set_shader_parameter("color", _faction_colour)

func _get_index_from_formation():
	_formation_index = blackboard.active_soldiers.find(self)
func set_formation_index(new_index):
	_formation_index = new_index
func get_formation_index():
	return _formation_index
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
	_custom_ready()

func _custom_ready():
	pass

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
func move(vector):
	velocity = velocity + lerp(velocity, vector * GlobalSettings.UNIT * speed, 0.5)
	move_and_slide()
	if velocity.length() > 20:
		anim_run()

func attack(enemy):
	for weapon in array_of_weapons:
		# add check to see if enemy is in range
		weapon.attack(enemy)

func hurt(damage):
	health -= damage
	anim_hurt()
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
# Private Variables
#---------------------------------------------------------------------------------------------------#
var SCENE = SceneLib.SOLDIER_KNIGHT
var _col_activated: bool = false

@onready var force_area: Area2D = %SoldierCollision





#-------------------------------------------------------------------------------
# Collision Functions
#-------------------------------------------------------------------------------
func activate_collision():
	if !_col_activated:
#




		_col_activated = true
		print("col ON")
	else: print("already active")

func deactivate_collision():
	if _col_activated:
#


		_col_activated = false
		print("col OFF")
	else: print("already not active")




#-------------------------------------------------------------------------------
# Animation Interface
#-------------------------------------------------------------------------------
func anim_run():
	animation_tree_mode.travel("Jog")

func anim_hurt():
	animation_tree_mode.travel("Hurt")


#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
