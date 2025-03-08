shader_type spatial;

uniform sampler2D depth_texture : hint_depth_texture;

void fragment() {
	ALBEDO = textureLod(depth_texture, SCREEN_UV, 0.0).rgb;
}