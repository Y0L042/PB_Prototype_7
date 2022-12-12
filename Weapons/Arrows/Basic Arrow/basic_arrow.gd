extends CharacterBody2D

signal TargetAquired

var target : set = set_target

@export var speed: float = 1 * GlobalSettings.UNIT : set = set_speed
@export var damage: float = 1 : set = set_damage

func set_target(new_target):
	target = new_target
	TargetAquired.emit()

func set_speed(new_speed):
	speed = new_speed * GlobalSettings.UNIT

func set_damage(new_damage):
	damage = new_damage



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await TargetAquired
	while true:
		move_to_target()




func move_to_target():
	var self_pos: Vector2 = get_global_position()
	var target_pos: Vector2 = target.get_global_position()

	velocity = self_pos.direction_to(target_pos) * speed
	self.rotate(velocity.angle())
	move_and_slide()
	check_collision()

func check_collision():
	var dist_limit: int = 10
	if self.get_global_position().distance_squared_to(target.get_global_position()) <= dist_limit*dist_limit:
		do_damage()
		self.queue_free()

func do_damage():
	if is_instance_valid(target):
		target.hurt(damage)
