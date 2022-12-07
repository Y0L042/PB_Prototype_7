extends Control

@onready var soldier_counter = %SoldierCounter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudStats.UpdateSoldierCount.connect(soldier_counter.set_soldier_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
