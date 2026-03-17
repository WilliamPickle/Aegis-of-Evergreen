shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float pixel_size = 10;
uniform float blur_amount : hint_range(0.0, 5.0) = 2;

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	float pixel_offset = 0.5 * cos(0.05 * TIME) + 1.0;

	vec2 pixel_uv = floor(SCREEN_UV * resolution / (pixel_size * (pixel_offset))) * pixel_size*pixel_offset / resolution;

	vec3 result = textureLod(SCREEN_TEXTURE, pixel_uv, blur_amount).rgb;

	COLOR.rgb = result;
}