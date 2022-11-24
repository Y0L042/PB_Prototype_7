extends BaseAIModule

class_name WanderAIModule


#---------------------------------------------------------------------------------------------------#
# Private Variables
#---------------------------------------------------------------------------------------------------#
var enemy_army: Variant = null
var friendly_armies: Array = []



#---------------------------------------------------------------------------------------------------#
# Public Variables
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export var set_CHASE_DIST: float = 5 : set = set_chase_distance
@export var FRIENDLY_AVOIDANCE_STRENGTH: float = 0.5
var CHASE_DIST: float = set_CHASE_DIST * GlobalSettings.UNIT
@export var wander_area: Area2D



#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_chase_distance(new_chase_distance: float):
	CHASE_DIST = new_chase_distance * GlobalSettings.UNIT

#---------------------------------------------------------------------------------------------------#
# Private Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _connect_to_parent_signals():
	_parent.army_sight_area.area_entered.connect(_on_army_sight_area_entered)
	_parent.army_sight_area.area_exited.connect(_on_army_sight_area_exited)
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Logic
#-------------------------------------------------------------------------------
func _logic():
	if enemy_army == null:
		_move_army(_parent.wander())
	else:
		var enemy_army_target: Vector2 = _parent.get_army_position().direction_to(enemy_army.get_army_position())
		if _parent.get_army_position().distance_to(enemy_army.get_army_position()) > CHASE_DIST:
			enemy_army = null
			return
		var avoid_faction_armies: Vector2 = Vector2.ZERO
		for army in friendly_armies:
			avoid_faction_armies += _parent.get_army_position().direction_to(army.get_army_position())
		avoid_faction_armies = avoid_faction_armies.normalized() * FRIENDLY_AVOIDANCE_STRENGTH
		var move_target: Vector2 = enemy_army_target - avoid_faction_armies
		_move_army(move_target)
#-------------------------------------------------------------------------------
# Movement Functions
#-------------------------------------------------------------------------------
func _move_army(target: Vector2):
	_parent.move_army(target)

#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _on_army_sight_area_entered(area: Area2D) -> void:
	print("army spotted")
	var spotted_object = area.get_parent()
	if spotted_object.is_in_group(_parent.TYPE):
		if spotted_object.faction != _parent.faction:
			print("enemy spotted")
			enemy_army = spotted_object
		if spotted_object.faction == _parent.faction:
			friendly_armies.append(spotted_object)

func _on_army_sight_area_exited(area: Area2D) -> void:
	var spotted_object = area.get_parent()
	if spotted_object.is_in_group(_parent.TYPE):
		if spotted_object.faction == _parent.faction:
			friendly_armies.erase(spotted_object)
#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------#
# Public Functions
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func ai_module_ready():
	_connect_to_parent_signals()
	print("Wander AI ready ")

	_set_up_debug()



#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func ai_module_physics_process(_delta: float):
	_logic()
	_draw_debug()


#---------------------------------------------------------------------------------------------------#
# %debug%
#---------------------------------------------------------------------------------------------------#
var debug_node: Node2D = Node2D.new()
func _set_up_debug():
	_parent.add_child(debug_node)
	debug_node.draw.connect(_draw)

func _draw_debug():
	debug_node.queue_redraw()

func _draw() -> void: #%Debug
	_debug_draw_dot(_parent.get_army_position(), Color(1,0,int(enemy_army == null),0.5), 1.5)

func _debug_draw_grid_dots(
	grid: Array,
	new_col = Color(0, 0, 1),
	new_rad = int(GlobalSettings.UNIT/2)
	):
	var col = new_col
	var rad = new_rad * GlobalSettings.UNIT
	for spot in grid:
		debug_node.draw_circle(spot, rad, col)

func _debug_draw_dot(
	new_pos: Vector2,
	new_col = Color(0, 0, 1),
	new_rad = int(GlobalSettings.UNIT/2)
	):
	var col = new_col
	var rad = new_rad * GlobalSettings.UNIT
	debug_node.draw_circle(new_pos, rad, col)

func _debug_draw_line(
	start: Vector2,
	end: Vector2,
	new_col = Color(0, 1, 1),
	new_width: float = 0.1
	):
	var col = new_col
	var width = new_width
	end += start
	debug_node.draw_line(start, end, col, width)

























