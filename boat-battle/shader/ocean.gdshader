shader_type spatial;

uniform vec3 WaterColor : source_color = vec3(0.0, 1.0, 0.98);
uniform vec3 FoamColor : source_color = vec3(1.0, 1.0, 1.0);
uniform float FoamThreshold : hint_range(0.0, 1.0) = 0.05;
uniform float FoamWidth : hint_range(0.0, 1.0) = 0.1;
uniform sampler2D depth_texture;

void fragment() {
    // Get depth information
    float depth = texture(depth_texture, SCREEN_UV).r;
    float water_depth = FRAGCOORD.z;
    float depth_diff = abs(depth - water_depth);

    // Foam calculation
    float foam = smoothstep(FoamThreshold, FoamThreshold + FoamWidth, depth_diff);
    foam = 1.0 - foam;

    // Mix water and foam colors
    vec3 final_color = mix(WaterColor, FoamColor, foam);

    ALBEDO = final_color;
}