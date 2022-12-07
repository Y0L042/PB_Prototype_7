extends Camera2D


var master : get = get_master
var target_position: Vector2 = Vector2.ZERO : set = set_target_position, get = get_target_position
@export var zoom_level: float = 3 : set = set_zoom_level, get = get_zoom_level
@onready var zoom_target: float = zoom_level : set = set_zoom_target, get = get_zoom_target
@export var MAX_ZOOMIN: float = 0.5
@export var MAX_ZOOMOUT: float = 0.075
@export_range (0,1) var ZOOM_SPEED: float = 0.5
@export_range (1,5) var ZOOM_INCREMENT: float = 1.5
@export var setMaster: bool = false



#-------------------------------------------------------------------------------
# SetGet
#-------------------------------------------------------------------------------
func set_master():
	master = get_parent()
func get_master():
	return master

func set_zoom_level(new_zoom_level):
	zoom_level = clampf(new_zoom_level, MAX_ZOOMOUT, MAX_ZOOMIN)
func get_zoom_level():
	return zoom_level

func set_zoom_target(new_target_level):
	zoom_target = clampf(new_target_level, MAX_ZOOMOUT, MAX_ZOOMIN)
func get_zoom_target():
	return zoom_target

func set_target_position(new_target_position: Vector2):
	target_position = new_target_position
	set_global_position(target_position)
func get_target_position():
	return target_position

#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _ready() -> void:
	if setMaster:
		set_master()


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if master != null:
		var spawn_pos: Vector2 = master._calc_soldier_array_center()
		if is_nan(spawn_pos.x) or is_nan(spawn_pos.y):
			spawn_pos = master.get_army_position()
		set_target_position(spawn_pos)#get_master().get_army_position())
	zoom_level = lerpf(zoom_level, zoom_target, ZOOM_SPEED)
	set_zoom(Vector2(zoom_level, zoom_level))



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("game_action_zoomin"):
		zoom_in()
	if Input.is_action_just_pressed("game_action_zoomout"):
		zoom_out()



func zoom_in():
	zoom_target *= ZOOM_INCREMENT


func zoom_out():
	zoom_target /= ZOOM_INCREMENT

