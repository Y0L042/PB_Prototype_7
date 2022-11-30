extends BaseSoldierAIModule

class_name StandardSoldierAIModule

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var _blackboard

var _engaged_distance: float : set = set_engaged_distance
var _isEngaged: bool : set = set_is_engaged

var _recall_limit = 3 * GlobalSettings.UNIT
var _isRecalled: bool
#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
var isAttackPossible: bool
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_engaged_distance(new_engaged_distance):
	_engaged_distance = new_engaged_distance * GlobalSettings.UNIT
func set_is_engaged(is_engaged):
	_isEngaged = is_engaged

func get_enemy():
	_parent.sight.sighted_enemy

func get_army_target():
	var target: Vector2
	if _parent._formation_index == -1:
		target = _parent._formation.center_position
	else:
		target = _parent._formation.vector_array[_parent._formation_index]
	return target
#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------


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
# Initialize
#-------------------------------------------------------------------------------
func ai_module_ready():
	_blackboard = _parent.blackboard

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func ai_module_physics_process(_delta: float):
	basic_ai()
#-------------------------------------------------------------------------------
# Actions
#-------------------------------------------------------------------------------


func simple_move(target):
	var direction: Vector2 = _parent.get_global_position().direction_to(target)

	var dist_check: int = int(_parent.get_global_position().distance_squared_to(target) > 10*10)
	var army_move_check: int = int(_parent._army._army_velocity.length() > 5)

	_parent.velocity = direction * GlobalSettings.UNIT * 4.75 * int(dist_check||army_move_check)
	_parent.move_and_slide()

func attack(enemy):
	_parent.attack(enemy)
#-------------------------------------------------------------------------------
# AI
#-------------------------------------------------------------------------------
func basic_ai():
#set_conditions
	var distance_to_party_target = _parent.get_global_position().distance_to(get_army_target())
	var attack_range: Vector2 = _parent.get_attack_range()
	var enemy = get_enemy()
	var distance_to_enemy = _parent.get_global_position().distance_to(enemy.get_global_position())
	if !_parent.sight.sightings.is_empty() and enemy != null and\
	distance_to_enemy <= _engaged_distance:
		_isEngaged = true
	if _isEngaged and enemy == null:
		_isEngaged = false
	if distance_to_enemy <=attack_range:
		if _isEngaged or _blackboard.isPartyAttacking:
			isAttackPossible = true
		else:
			isAttackPossible = false
	if _isEngaged and distance_to_party_target > _recall_limit:
		_isRecalled = true
		_isEngaged = false
	else:
		_isRecalled = false

#do_actions
	if isAttackPossible:
		attack(enemy)
		return 1
	if _isEngaged and (distance_to_enemy >= attack_range and enemy != null):
		simple_move(enemy.get_global_position())
		return 2
	if _isRecalled:
		simple_move(get_army_target())
		return 3
	simple_move(get_army_target())
	return -1


#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
