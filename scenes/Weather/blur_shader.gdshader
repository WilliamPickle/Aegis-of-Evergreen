//shader_type canvas_item;
//
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//uniform float blur_amount : hint_range(0.0, 5.0) = 5;
//
//
//
//void vertex() {
	//// Called for every vertex the material is visible on.
//}
//
//void fragment() {
	//// Called for every pixel the material is visible on.
	//vec3 result = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount).rgb;
	//COLOR.rgb = result;
//}
//
////void light() {
////	// Called for every pixel for every light affecting the CanvasItem.
////	// Uncomment to replace the default light processing function with this one.
////}



//shader_type canvas_item;
//
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//uniform float pixel_size = 1;
//uniform vec2 screen_size = vec2(740.0, 460.0);
//
//void fragment() {
	//vec4 result = textureLod(SCREEN_TEXTURE, SCREEN_UV/vec2(4,4), 0.5); // FROM VIDEO
	//
	//vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
//
    //vec2 pixel_uv = floor(SCREEN_UV * resolution / pixel_size) * pixel_size / resolution;
	//COLOR = result;
    ////COLOR = texture(SCREEN_TEXTURE, pixel_uv);
//}





shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float pixel_size = 10;
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	float pixel_offset = 0.5 * cos(0.05 * TIME) + 1.0;
	// snap UVs to pixel grid
	vec2 pixel_uv = floor(SCREEN_UV * resolution / (pixel_size * (pixel_offset))) * pixel_size*pixel_offset / resolution;

	// apply blur using mipmaps
	vec3 result = textureLod(SCREEN_TEXTURE, pixel_uv, blur_amount).rgb;

	COLOR.rgb = result;
	//COLOR.a = 1.0;
}