extends Marker2D


var _parent
var active_instances: Array = []
@onready var timer: Timer = $Timer

@export var _troops: Array[Resource] : get = get_troops
@export var _ai: Resource
#@export_category("Spawn Config")
@export_range(1,60) var delay: float = 1 : set = set_delay
@export var waves: int = -1
@export var max_active_instances: int = -1
@export var active: bool = true
@export_group("Event Settings")
@export var enable_disable_zone: bool = false
@export var disable_zone: Area2D


func set_delay(new_delay: float):
	delay = new_delay
	if timer != null:
		timer.set_wait_time(delay)

func set_waves(new_waves: int):
	waves = new_waves

func set_max_active_instances(new_max_active_instances: int):
	max_active_instances = new_max_active_instances


func _ready() -> void:
	_parent = get_parent()
	timer.timeout.connect(timer_timeout)
	timer.start(delay)
	if enable_disable_zone and disable_zone != null:
		disable_zone.area_entered.connect(disable_zone_entered)
		disable_zone.area_exited.connect(disable_zone_exited)

func timer_timeout():
	if active:
		if waves == 0:
			active = false
			return

		var LIMIT_REACHED: bool = false
		if !active_instances.is_empty() and max_active_instances == active_instances.size():
			LIMIT_REACHED = true
		else: LIMIT_REACHED = false
		if !LIMIT_REACHED:# dirty hack. try to use process or something to solve return problem
			var army = _spawn_enemies()
			army._soldier_manager.ArmyIsDefeated.connect(remove_army_from_active_instances)
			active_instances.append(army)
			if waves != -1:
				waves -= 1
	timer.start(delay)

func _physics_process(delta: float) -> void:
#	random_spawning()
	pass

func random_spawning():
	var temp_timer = get_tree().create_timer(delay)
	await temp_timer.timeout
	if waves == 0:
		active = false
		return

	if !active_instances.is_empty() and max_active_instances == active_instances.size():
		active = true
	else: active = false

	if !active:# dirty hack. try to use process or something to solve return problem
		var army = _spawn_enemies()
		army._soldier_manager.ArmyIsDefeated.connect(remove_army_from_active_instances)
		active_instances.append(army)

		if waves != -1:
			waves -= 1



func _spawn_enemies():
	var _spawn_point: Vector2 = get_global_position()
	var army = SceneLib.spawn_child(SceneLib.ENEMY_ARMY, get_tree().get_root(), _spawn_point)
	army.set_army_position(_spawn_point)
	if _ai != null:
		_ai = _ai.duplicate()
		army.set_ai_module(_ai)
	if !_troops.is_empty():
		army.set_initial_troop(_troops[get_troop_index()])
	return army

func get_troop_index():
	return 0

func remove_army_from_active_instances(ignore, new_army):
	active_instances.erase(new_army)

func get_troops():
	return _troops


func disable_zone_entered(area: Area2D):
	var spotted_object = area.get_parent()
	if spotted_object.faction == "Player":
		active = false
		print("zone entered")



func disable_zone_exited(area: Area2D):
	var spotted_object = area.get_parent()
	if spotted_object.faction == "Player":
		active = true
		print("zone exited")


