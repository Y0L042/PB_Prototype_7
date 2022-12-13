extends Sprite2D


var faction_colour: Color : set = set_faction_colour
@onready var visibility_notifier = $VisibleOnScreenNotifier2D

func set_faction_colour(new_colour: Color):
	faction_colour.r = new_colour.r
	faction_colour.g = new_colour.g
	faction_colour.b = new_colour.b
	faction_colour.a = get_modulate().a
	set_modulate(faction_colour)

func _ready() -> void:
	self.set_visible(false)
	visibility_notifier.screen_exited.connect(visibility_turn_off)
	visibility_notifier.screen_entered.connect(visibility_turn_on)

func visibility_turn_on():
	self.set_visible(true)
func visibility_turn_off():
	self.set_visible(false)

