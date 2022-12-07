extends Sprite2D


var faction_colour: Color : set = set_faction_colour

func set_faction_colour(new_colour: Color):
	faction_colour.r = new_colour.r
	faction_colour.g = new_colour.g
	faction_colour.b = new_colour.b
	faction_colour.a = get_modulate().a
	set_modulate(faction_colour)

