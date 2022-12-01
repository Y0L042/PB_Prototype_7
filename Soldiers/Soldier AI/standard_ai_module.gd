extends BaseSoldierAIModule

class_name StandardSoldierAIModule

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var _engaged_distance: float = 3 * GlobalSettings.UNIT: set = set_engaged_distance
var _isEngaged: bool : set = set_is_engaged

var _recall_limit = 4 * GlobalSettings.UNIT
var _isRecalled: bool : set = set_is_engaged
#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
var isAttackPossible: bool
#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_engaged_distance(new_engaged_distance):
	_engaged_distance = new_engaged_distance * GlobalSettings.UNIT


func get_enemy():
	return _parent.sight.sighted_enemy

func get_army_target():
	if _parent == null: return
	var target: Vector2
	if _parent._formation_index == -1:
		target = _parent._formation.center_position
	else:
		target = _parent._formation.vector_array[_parent._formation_index]
	return target

func set_is_engaged(new_engaged):
	_isEngaged = new_engaged
	if _isEngaged:
		_parent.activate_collision()
	if !_isEngaged:
		_parent.deactivate_collision()
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
	pass

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func ai_module_physics_process(_delta: float):
	basic_ai()
#-------------------------------------------------------------------------------
# Actions
#-------------------------------------------------------------------------------
func move(vector):
	_parent.velocity = vector * GlobalSettings.UNIT * 4.75
	_parent.move_and_slide()
	if _parent.velocity.length() > 20:
		_parent.anim_run()

func simple_move(target):
	var direction: Vector2 = _parent.get_global_position().direction_to(target)
	var dist_check: int = int(_parent.get_global_position().distance_squared_to(target) > 10*10)
	return direction * int(dist_check)

func simple_move_army(target):
	var direction: Vector2 = _parent.get_global_position().direction_to(target)
	var dist_check: int = int(_parent.get_global_position().distance_squared_to(target) > 10*10)
	var army_move_check: int = int(_parent._army._army_velocity.length() > 5)
	return direction * int(dist_check||army_move_check)

func check_friendly_collision(mov_vec: Vector2):
	var collision_limit: float = 2 * GlobalSettings.UNIT
	collision_limit *= collision_limit
	var LIMIT: float = 0.75
	if _parent.force_area.contacts.is_empty(): return mov_vec
	var collisions: Array = _parent.force_area.contacts
	var position: Vector2 = _parent.get_global_position()
	for collision in collisions:
		var col_dir: Vector2 = position.direction_to(collision)
		var dot: float = col_dir.dot(mov_vec)
		if dot > LIMIT:
			if position.distance_squared_to(collision) <=collision_limit:
				mov_vec -= col_dir
#				mov_vec = Vector2.ZERO
			return mov_vec
	return mov_vec

#	_parent.velocity = direction * GlobalSettings.UNIT * 4.75 * int(dist_check||army_move_check)
#	_parent.move_and_slide()

func attack(enemy):
	_parent.attack(enemy)
#-------------------------------------------------------------------------------
# AI
#-------------------------------------------------------------------------------
func basic_ai():
#set_conditions
	var distance_to_party_target = _parent.get_global_position().distance_to(get_army_target())
	var attack_range: float = _parent.get_attack_range()
	var enemy = get_enemy()
	var distance_to_enemy = -1
	if enemy != null:
		distance_to_enemy = _parent.get_global_position().distance_to(enemy.get_global_position())

	if !_parent.sight.sightings.is_empty() and enemy != null and\
	distance_to_enemy <= _engaged_distance:
		_isEngaged = true


	if _isEngaged and enemy == null:
		_isEngaged = false


	if distance_to_enemy <=attack_range:
		if _isEngaged or blackboard.isArmyAttacking:
			isAttackPossible = true
		else:
			isAttackPossible = false

	if _isEngaged and distance_to_party_target > _recall_limit:
		_isRecalled = true
		_isEngaged = false
		isAttackPossible = false
	else:
		_isRecalled = false

#do_actions
	var mov_vec: Vector2 = Vector2.ZERO
	if isAttackPossible:
		attack(enemy)
		print("Attack enemy ", enemy)
		return 1
	if _isEngaged and (distance_to_enemy >= attack_range and enemy != null):
		mov_vec += simple_move(enemy.get_global_position())
		mov_vec += simple_move_army(get_army_target()) * 0.35
		mov_vec = mov_vec.normalized()
#		mov_vec = check_friendly_collision(mov_vec)
		move(mov_vec)
#		print("pursue enemy ", enemy)
		return 2
	if _isRecalled:
		mov_vec += simple_move_army(get_army_target())
		move(mov_vec)
#		print("is recalled")
		return 3
	mov_vec += simple_move_army(get_army_target())
	move(mov_vec)
	return -1



#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
