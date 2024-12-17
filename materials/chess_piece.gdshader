shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(1.0);
uniform float shine_speed : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float shine_size : hint_range(0.01, 1.0, 0.01) = 0.01;
uniform float shine_frequency: hint_range(0.1, 10.0, 0.1) = 1.0;

uniform bool apply_effect = false;

void fragment() {
	if (apply_effect) {
		float shine = step(1.0 - shine_size * 0.3, 0.5 + 0.5 * sin((UV.x - UV.y + TIME * shine_speed) * shine_frequency));
		COLOR.rgb = mix(COLOR.rgb, shine_color.rgb, shine * shine_color.a);
	} else {
		COLOR = texture(TEXTURE, UV);
	}
}
