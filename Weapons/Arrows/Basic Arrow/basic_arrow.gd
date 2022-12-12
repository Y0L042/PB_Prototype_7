extends CharacterBody2D

signal TargetAquired

@onready var pivot: Marker2D = %Pivot

var _delta: float
var start_point: Vector2
var target : set = set_target

@export var _debug_vel: Vector2
@export var speed: float = 10 * GlobalSettings.UNIT : set = set_speed
@export var distance: float = 10 * GlobalSettings.UNIT : set = set_distance
@export var damage: float = 1 : set = set_damage

func set_target(new_target):
	target = new_target
	TargetAquired.emit()

func set_speed(new_speed):
	speed = new_speed * GlobalSettings.UNIT

func set_distance(new_distance):
	distance = new_distance * GlobalSettings.UNIT

func set_damage(new_damage):
	damage = new_damage



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	await TargetAquired
	set_physics_process(true)
	start_point = global_position



func _physics_process(delta: float) -> void:
	_delta = delta
	if is_instance_valid(target):
		move_to_target()
	else:
		queue_free()
	_debug_vel = velocity



func move_to_target():
	var self_pos: Vector2 = get_global_position()
	var target_pos: Vector2 = target.get_global_position()

	velocity = self_pos.direction_to(target_pos) * speed  # * _delta
	pivot.set_rotation(velocity.angle() + PI/2)
	move_and_slide()
	check_collision()

	var traveled_dist: float = start_point.distance_squared_to(self_pos)
	if traveled_dist >= distance*distance:
		self.queue_free()

func check_collision():
	var dist_limit: int = 0.5 * GlobalSettings.UNIT
	var dist_to_target: float = self.get_global_position().distance_squared_to(target.get_global_position())
	if dist_to_target <= dist_limit*dist_limit:
		do_damage()
		self.queue_free()

func do_damage():
	if is_instance_valid(target):
		target.hurt(damage)
