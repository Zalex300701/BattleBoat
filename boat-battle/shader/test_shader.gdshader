shader_type spatial;

uniform vec3 WaterColor : source_color = vec3(0.0, 1.0, 0.98);
uniform vec3 FoamColor : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 DepthColor : source_color = vec3(0.0, 0.5, 0.8);
uniform float FoamThreshold : hint_range(0.0, 1.0) = 0.05;
uniform float FoamWidth : hint_range(0.0, 1.0) = 0.1;
uniform float DepthFade : hint_range(0.0, 5.0) = 1.0;
uniform sampler2D depth_texture; // Plain sampler2D, no hint

void fragment() {
    // Get depth information
    float depth = texture(depth_texture, SCREEN_UV).r;
    float water_depth = FRAGCOORD.z;
    float depth_diff = abs(depth - water_depth);

    // Foam calculation (for objects above or intersecting)
    float foam = smoothstep(FoamThreshold, FoamThreshold + FoamWidth, depth_diff);
    foam = 1.0 - foam;

    // Depth effect (for objects below)
    float depth_factor = 0.0;
    if (depth > water_depth) { // Object is below water
        depth_factor = clamp((depth - water_depth) * DepthFade, 0.0, 1.0);
    }
    vec3 base_color = mix(WaterColor, DepthColor, depth_factor);

    // Mix with foam
    vec3 final_color = mix(base_color, FoamColor, foam);

    ALBEDO = final_color;
}