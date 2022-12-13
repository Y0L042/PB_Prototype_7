extends Node2D

class_name Army

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
signal IAMREADY

const TYPE: String = "ARMY"
var _delta: float
@onready var _army_position: Vector2 = get_global_position() : set = set_army_position # Vector2.ZERO
var _army_velocity: Vector2 = Vector2.ZERO

@onready var audio_stream = $AudioStreamPlayer2D

#-------------------------------------------------------------------------------
# Soldier-Related Variables
#-------------------------------------------------------------------------------
@export var _initial_troop: Resource : set = set_initial_troop
var _soldier_manager: SoldierManager #: set = set_soldier_manager#: Resource# : set = set_soldier_manager # commented out debug 16:18 Mo, 28-11-2022

#-------------------------------------------------------------------------------
# % debug %
#-------------------------------------------------------------------------------
var _visual_debugger := VisualDebugger.new(self)
#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
var enemy_army # used for necromancy
#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------

@export var army_speed: float : set = set_army_speed
#-------------------------------------------------------------------------------
# Blackboard
#-------------------------------------------------------------------------------
var blackboard: ArmyBlackboard
@export var faction: String : set = set_faction
@onready var army_id: int = get_instance_id() : set = set_army_id
@export_color_no_alpha var faction_colour: Color = Color(0.5, 0.8, 0.5, 1) #: set = set_faction_colour# used with outline shader
@onready var formation
var flag_sort_formation: bool = true : set = set_flag_sort_formation
var flag_update_formation_volume: bool = true
var isArmyAttacking: bool = false : set = set_isArmyAttacking
#-------------------------------------------------------------------------------
# "Features"
#-------------------------------------------------------------------------------
@onready var army_sight_area: Area2D = %Army_Sight


#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_initial_troop(new_troop):
	_initial_troop = new_troop
	if _soldier_manager != null:
		_soldier_manager.set_soldier_troop(_initial_troop)

func set_isArmyAttacking(isAttacking: bool):
	isArmyAttacking = isAttacking
	blackboard.isArmyAttacking = isArmyAttacking

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

func set_faction(new_faction):
	faction = new_faction

#func set_faction_colour(new_color: Color):
#	faction_colour = new_color

func set_army_id(new_id):
	army_id = new_id


func set_formation_volume(new_volume):
	formation.set_volume(new_volume)

func set_flag_sort_formation(flag):
	flag_sort_formation = flag
func set_flag_sort_formation_true():
	flag_sort_formation = true
func set_flag_update_formation_volume(flag):
	flag_update_formation_volume = flag
func set_flag_update_formation_volume_true():
	flag_update_formation_volume = true

func set_soldier_manager(new_soldier_manager):
	if new_soldier_manager == null:
		printerr("Error: Soldier manager scene is empty!", self)
		return -1
	_soldier_manager = new_soldier_manager
	_soldier_manager.set_parent(self)
	if _initial_troop == null: return
	_soldier_manager.set_soldier_troop(_initial_troop)


#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _init() -> void:
	set_y_sort_enabled(true)
	_custom_init()
	add_to_group(TYPE)


func _custom_init():
	pass

func _ready() -> void:
	_create_blackboard()
	formation = blackboard.formation
#	formation.GridGenerated.connect(set_flag_sort_formation_true)
	set_soldier_manager(SoldierManager.new())
	_custom_ready()



func _custom_ready():
	pass

func _create_blackboard():
	var new_faction = faction
	var new_army = self
	var new_army_id = army_id
	var new_active_soldiers = []
	var new_formation = GridObject.new()
	var new_faction_colour = faction_colour
	var new_move_order = Vector2.ZERO
	var new_isArmyAttacking = isArmyAttacking
	blackboard = ArmyBlackboard.new(
		new_faction,
		new_army,
		new_army_id,
		new_active_soldiers,
		new_formation,
		new_faction_colour,
		new_move_order,
		new_isArmyAttacking,
	)
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	_delta = delta
	check_flags()
	_custom_process(delta)

func check_flags():
	if _soldier_manager != null:
		sort_and_set_soldier_index()
	if blackboard != null and _soldier_manager != null:
		update_formation_volume()
#		call_deferred("update_formation_volume")

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
		formation.set_rotation(  lerp_angle(formation.rotation, _army_velocity.angle(), 0.1)  )

func sort_and_set_soldier_index():
	if !isArmyAttacking and flag_sort_formation:
		print("army_sorted ", self)
		var array: Array = _soldier_manager.active_soldiers_array
		for idx_i in array.size():
			var idx_j = idx_i
			while idx_j > 0 and array[idx_j - 1].formation_order > array[idx_j].formation_order:
				var temp = array[idx_j] #swap
				array[idx_j] = array[idx_j - 1]
				array[idx_j - 1] = temp
				idx_j -= 1
		for soldier_idx in array.size():
			array[soldier_idx]._formation_index = soldier_idx

		flag_sort_formation = false

func update_formation_volume():
	if !isArmyAttacking and flag_update_formation_volume:
		blackboard.adjust_formation_volume(blackboard.active_soldiers.size())
		flag_sort_formation = false

#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func receive_necromanced_army(new_army):
	if _soldier_manager != null:
		_soldier_manager.necromance_army(new_army)

func army_is_dead():
#		_soldier_manager.queue_free()
		print("Army:   ", self, "  is ded")
		self.queue_free()
#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func _calc_soldier_array_center(arr: Array = _soldier_manager.active_soldiers_array):
	var avg := Vector2.ZERO
	for soldier in arr:
		avg += soldier.get_global_position()
	avg /= arr.size()
	return avg


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#








