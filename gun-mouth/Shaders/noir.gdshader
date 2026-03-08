shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float saturation : hint_range(0.0, 1.0) = 0.2;
uniform float contrast = 1.5;
uniform float brightness = 0.125;
uniform float grain_scale = 250.0;
uniform float grain_density : hint_range(0.0, 1.0) = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
	
	POSITION = vec4(VERTEX, 1.0);
}

vec2 random2(vec2 st) {
	st = vec2(dot(st, vec2(127.1, 311.7)),
				dot(st, vec2(269.5, 183.3)));
	return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

float noise(vec2 st, float seed) {
	vec2 cell_id = floor(st);
	vec2 cell_uv = fract(st);
	vec2 u = cell_uv*cell_uv*(3.0-2.0*cell_uv);
	
	return mix(
		mix(
			dot(random2(cell_id + vec2(0.0, 0.0) + seed), cell_uv - vec2(0.0, 0.0)),
			dot(random2(cell_id + vec2(1.0, 0.0) + seed), cell_uv - vec2(1.0, 0.0)),
			u.x
		),
		mix(
			dot(random2(cell_id + vec2(0.0, 1.0) + seed), cell_uv - vec2(0.0, 1.0)),
			dot(random2(cell_id + vec2(1.0, 1.0) + seed), cell_uv - vec2(1.0, 1.0)),
			u.x
		),
		u.y
	);
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec2 aspect = normalize(VIEWPORT_SIZE);
	
	// base color
	vec4 screen_sample = texture(screen_texture, vec2(UV.x, 1.0 - UV.y));
	vec3 col = screen_sample.rgb;
	
	// desaturation
	vec3 luminance = vec3(0.2126, 0.7152, 0.0722);
	float desaturated_color = dot(col.rgb, luminance);
	col = mix(vec3(desaturated_color), col.rgb, saturation);
	
	// constrast and brightness
	col = (col - 0.5) * max(contrast, 0.0) + 0.5f;
	col += brightness;
	
	// grain noise
	col *= (
		noise(UV * aspect * grain_scale, TIME) 
		* grain_density + 1.0 - grain_density
	);
	
	ALBEDO = col;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
