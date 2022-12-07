shader_type canvas_item;

//hurt
uniform bool active = false;

//faction colour
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tint_effect_factor : hint_range(0, 1) = 0.0;

void fragment() {
	// Replaces all but alpha to white if active = true
	vec4 original_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, original_color.a); 
	vec4 new_color = original_color;
	if (active == true)
	{
		new_color = white_color;
	}
	
	vec4 tint = new_color * tint_color;
	vec4 final_colour = mix(new_color, tint, tint_effect_factor);
	
	COLOR = final_colour;
}