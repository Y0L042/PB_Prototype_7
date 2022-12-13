#extends BaseSoldier

extends CharacterBody2D

#class_name BaseSoldier


#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
signal CustomReady
signal BlackboardIsReady
signal SoldierIsDead
@export @onready var _ai_module: Resource : set = set_ai_module
var _parent
var _formation_index: int : set = set_formation_index, get = get_formation_index
var isAttacking: bool = false : set = set_isAttacking, get = get_isAttacking

@onready var TYPE = %TYPE
@onready var SCENE: PackedScene
func set_SCENE():
	SCENE = TYPE.TYPE
@onready var flag_visibility_notifier = $VisibleOnScreenNotifier2D
var debug_isVisible: bool = false

var _col_activated: bool = false

@onready var force_area: Area2D = %SoldierCollision
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
@export var base_stats: Resource : set = set_base_stats
@export var health: float = 5.0 : set = set_health
@export var speed: float = 5.0 : set = set_speed
@export var formation_order: float = 1.0 : set = set_formation_order
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
	BlackboardIsReady.emit() # make _ready wait for blackboard, avoid bugs with ai starting too soon

func set_base_stats(new_base_stats: Resource):
	base_stats = new_base_stats
	health = base_stats.health
	speed = base_stats.speed
	formation_order = base_stats.order

func set_formation_order(new_order):
	formation_order = new_order

func set_isAttacking(is_attacking):
	isAttacking = is_attacking
func get_isAttacking():
	return isAttacking

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
	SoldierIsDead.emit()
	_spawn_blood_splatter()
	blackboard.active_soldiers.erase(self)
	blackboard.deregister_soldier(self)
	self.queue_free()

func set_faction_stuff():
	set_actor_faction_outline()
	set_actor_tint_colour()

func set_actor_faction_outline():
	shadow.get_material().set_shader_parameter("color", _faction_colour)

func set_actor_tint_colour():
	body_sprite.get_material().set_shader_parameter("tint_color", _faction_colour)

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
	set_SCENE()
	_ai_module_ready()
	_custom_ready()
	connect_to_signals()
	set_physics_process(false) #physics process starts before blackboard is ready
	await BlackboardIsReady
	print("blackboard is ready")
	set_physics_process(true)

func connect_to_signals():
	flag_visibility_notifier.screen_exited.connect(visibility_turn_off)
	flag_visibility_notifier.screen_entered.connect(visibility_turn_on)


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
#	_formation_index = get_position_in_formation()
	pass

func _ai_module_process(_delta: float):
	# Run AI Module _physics
	if _ai_module != null:
		_ai_module.ai_module_physics_process(_delta)

func _custom_process(_delta: float):
	pass # leave empty for subclasses

#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _spawn_blood_splatter(): # temp
	var blood_splatter = SceneLib.spawn_child(SceneLib.fx_sprite_blood_splatter_1, SceneManager._root_manager.current_map, get_global_position())
	blood_splatter.set_faction_colour(_faction_colour)

func visibility_turn_on():
	self.set_visible(true)
	debug_isVisible = self.visible
func visibility_turn_off():
	self.set_visible(false)
	debug_isVisible = self.visible
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
