shader_type spatial;

uniform vec3 WaterColor: source_color = vec3(0.0, 1.0, 0.98);


void fragment() {
	// Apply final color
	ALBEDO = WaterColor;
}