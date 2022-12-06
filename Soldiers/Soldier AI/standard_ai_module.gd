extends BaseSoldierAIModule

class_name StandardSoldierAIModule

#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var _engaged_distance: float = 3 * GlobalSettings.UNIT: set = set_engaged_distance
var _isEngaged: bool : set = set_is_engaged

var _recall_limit = 6 * GlobalSettings.UNIT
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


func get_enemy():
	return _parent.sight.sighted_enemy

func get_army_target():
	if _parent == null: return
	var target: Vector2
	if _parent._formation_index == -1:
		target = _parent._formation.center_position
	else:
		if _parent._formation.vector_array.is_empty(): return _parent._formation.center_position
		target = _parent._formation.vector_array[_parent._formation_index]
	return target

func set_is_engaged(new_engaged):
	_isEngaged = new_engaged

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
	_parent.velocity = lerp(_parent.velocity, vector * GlobalSettings.UNIT * _parent.speed, 0.5)
	_parent.move_and_slide()
	if _parent.velocity.length() > 20:
		_parent.anim_run()

func simple_move(target):
	var direction: Vector2 = _parent.get_global_position().direction_to(target)
	var dist_check: int = int(_parent.get_global_position().distance_squared_to(target) > 10*10)
	return direction * int(dist_check)

func simple_move_army(target):
	var direction: Vector2 = _parent.get_global_position().direction_to(target)
	var dist_check: int = int(_parent.get_global_position().distance_squared_to(target) > 25*25)
	var army_move_check: int = int(_parent._army._army_velocity.length() > 5)
	return direction * int(dist_check||army_move_check)

func check_force_collisions(mov_vec: Vector2):
	var collision_limit: float = 0.5 * GlobalSettings.UNIT
	collision_limit *= collision_limit
	var LIMIT: float = 0.75
	if _parent.force_area.contacts.is_empty():
		return mov_vec
	var collisions: Array = _parent.force_area.contacts
	var position: Vector2 = _parent.get_global_position()
	for collision in collisions:
		var col_dir: Vector2 = position.direction_to(collision)
		var dot: float = col_dir.dot(mov_vec)
		if dot > LIMIT:
			if position.distance_squared_to(collision) <=collision_limit:
				mov_vec = -col_dir * 1.5
#				mov_vec = Vector2.ZERO
			return mov_vec
	return mov_vec



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
		set_is_engaged(true)#_isEngaged = true

	if _isEngaged and enemy == null:
		set_is_engaged(false)#_isEngaged = false
		pass

	if distance_to_enemy <= attack_range:
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

#set_collision
#	if _isEngaged:
#		_parent.activate_collision()
#	else:
#		if _isRecalled:
#			_parent.deactivate_collision()

#do_actions
	var mov_vec: Vector2 = Vector2.ZERO
	if isAttackPossible:
		attack(enemy)
#		mov_vec += simple_move(enemy.get_global_position())
		mov_vec = mov_vec.normalized()
		check_force_collisions(mov_vec)
	elif _isEngaged and (distance_to_enemy >= attack_range and enemy != null):
		mov_vec += simple_move(enemy.get_global_position())
		mov_vec += simple_move_army(get_army_target()) * 0.35
		mov_vec = mov_vec.normalized()
		check_force_collisions(mov_vec)
	elif _isRecalled:
		mov_vec += simple_move_army(get_army_target())
	else:
		mov_vec += simple_move_army(get_army_target())
		check_force_collisions(mov_vec)
	move(mov_vec)
	return -1



#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
