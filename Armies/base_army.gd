extends Node2D

class_name Army

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
const TYPE: String = "ARMY"
var _delta: float
@onready var _army_position: Vector2 = get_global_position() : set = set_army_position # Vector2.ZERO
var _army_velocity: Vector2 = Vector2.ZERO

#-------------------------------------------------------------------------------
# % debug %
#-------------------------------------------------------------------------------
var _visual_debugger := VisualDebugger.new(self)

#-------------------------------------------------------------------------------
# Soldier-Related Variables
#-------------------------------------------------------------------------------
@export var _soldier_manager: Resource : set = set_soldier_manager

#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# "Features"
#-------------------------------------------------------------------------------
var blackboard: Dictionary = {
	"faction" : "INSERT FACTION HERE",
	"army_id" : "INSERT ARMY INSTANCE ID HERE",

	"formation" : GridObject.new(),
	"army_colour" : army_colour,
	"move_order" : Vector2.ZERO,
}
@onready var army_sight_area: Area2D = %Army_Sight
@onready var formation = blackboard.formation

@export var faction: String : set = set_faction
@onready var army_id: int = get_instance_id() : set = set_army_id
#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export_color_no_alpha var army_colour: Color : set = set_army_colour# used with outline shader
@export var army_speed: float : set = set_army_speed
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_army_position(new_army_position: Vector2):
	_army_position = new_army_position
	# update move_order
	blackboard.move_order = _army_position
	formation.center_position = _army_position

func get_army_position():
	return _army_position

func set_army_speed(new_army_speed: float):
	army_speed = new_army_speed
	army_speed *= GlobalSettings.UNIT

func set_army_colour(new_colour: Color):
	army_colour = new_colour
	blackboard.army_colour = army_colour

func set_faction(new_faction):
	faction = new_faction
	blackboard.faction = faction

func set_army_id(new_id):
	army_id = new_id
	blackboard.army_id = army_id

func set_soldier_manager(new_soldier_manager):
	if new_soldier_manager == null:
		print("Error: Soldier manager scene is empty!")
		return -1
	_soldier_manager = new_soldier_manager
#	_soldier_manager.set_parent(self)
#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _init() -> void:
	_custom_init()
	add_to_group(TYPE)

func _custom_init():
	pass

func _ready() -> void:
	_custom_ready()
#	set_global_position(get_position()) # for position offset debug sat, 21/11/2022 10:40
#	set_army_position(get_global_position()) # for position offset debug sat, 21/11/2022 10:40

func _custom_ready():
	pass
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	_delta = delta
	_custom_process(delta)


@warning_ignore(unused_parameter)
func _custom_process(delta: float):
	pass

#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------
func _move():
	var delta: float = _delta
	_army_position += _army_velocity * delta
	formation.set_center_position(_army_position)

#-------------------------------------------------------------------------------
# Formation Functions
#-------------------------------------------------------------------------------
func _set_formation_rotation():
	if _army_velocity != Vector2.ZERO:
		formation.set_rotation(_army_velocity.angle())




#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func _calc_soldier_array_center(arr: Array):
	var avg := Vector2.ZERO
	for soldier in arr:
		avg += soldier.get_global_position()
	avg /= arr.size()
	return avg


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#








