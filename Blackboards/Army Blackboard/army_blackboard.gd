extends RefCounted

class_name ArmyBlackboard


#---------------------------------------------------------------------------------------------------#
# Variables
#---------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------
# Public
#-------------------------------------------------------------------------------
var faction: String : set = set_faction, get = get_faction
var army: Variant : set = set_army, get = get_army
var army_id: Variant : set = set_army_id, get = get_army_id
var active_soldiers: Array : set = set_active_soldiers, get = get_active_soldiers
var formation: GridObject : set = set_formation, get = get_formation
var faction_colour: Color : set = set_faction_colour, get = get_faction_colour
var move_order: Vector2 = Vector2.ZERO : set = set_move_order, get = get_move_order
var isArmyAttacking: bool = false : set = set_isArmyAttacking, get = get_isArmyAttacking

#---------------------------------------------------------------------------------------------------#
# SetGet
#---------------------------------------------------------------------------------------------------#
func set_faction(new_faction):
	faction = new_faction
func get_faction():
	return faction

func set_army(new_army):
	army = new_army
func get_army():
	return army

func set_army_id(new_army_id):
	army_id = new_army_id
func get_army_id():
	return army_id

func set_active_soldiers(new_array):
	active_soldiers = new_array
func get_active_soldiers():
	return active_soldiers

func set_formation(new_formation: GridObject):
	formation = new_formation
func get_formation():
	return formation

func set_faction_colour(new_colour: Color):
	faction_colour = new_colour
func get_faction_colour():
	return faction_colour

func set_move_order(new_order: Vector2):
	move_order = new_order
func get_move_order():
	return move_order

func set_isArmyAttacking(new_state: bool):
	isArmyAttacking = new_state
func get_isArmyAttacking():
	return isArmyAttacking

#---------------------------------------------------------------------------------------------------#
# Initialization
#---------------------------------------------------------#
func _init(
	new_faction,
	new_army,
	new_army_id,
	new_active_soldiers,
	new_formation,
	new_faction_colour,
	new_move_order,
	new_isArmyAttacking,
) -> void:
	faction = new_faction
	army = new_army
	army_id = new_army_id
	active_soldiers = new_active_soldiers
	formation = new_formation
	faction_colour = new_faction_colour
	move_order = new_move_order
	isArmyAttacking = new_isArmyAttacking
