extends Control


@onready var lbl_soldier_count: Label = %SoldierCount
var soldier_count: int = 0 : set = set_soldier_count

func set_soldier_count(new_count):
	soldier_count = new_count
	lbl_soldier_count.text = str(soldier_count)
