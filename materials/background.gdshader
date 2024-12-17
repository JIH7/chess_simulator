shader_type canvas_item;

uniform vec4 bgColor : source_color = vec4(1.0);
uniform vec4 bgColorAlt: source_color = vec4(1.0);
uniform float speed : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float scale : hint_range(0.1, 10.0, 0.1) = 1.0;
uniform sampler2D noise_texture;

float noise(vec2 v) {
	return texture(noise_texture, v).r;
}

void fragment() {
	vec2 uv = UV * scale;
	float time = TIME * speed;

	float blob1 = sin(uv.x * 3.0 + time) + sin(uv.y * 3.0 + time);
	float blob2 = sin(uv.x * 2.0 - time) + sin(uv.y * 3.0 + time);
	float blob3 = noise(uv + vec2(time * 0.1, time * 0.1)) * 2.0 - 1.0;

	float combined = blob1 + blob2 + blob3;

	float smooth_blobs = smoothstep(0.0, 1.0, combined);

	COLOR = mix(bgColor, bgColorAlt, smooth_blobs);
}
