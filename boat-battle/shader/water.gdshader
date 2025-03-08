shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_disabled;

// Uniforms for customization
uniform vec4 water_color : source_color = vec4(0.0, 0.4, 0.8, 1.0); // Blue color
uniform float transparency_depth : hint_range(0.0, 10.0) = 2.0; // Depth at which it becomes fully opaque

void fragment() {
    // Get the depth from the vertex to the camera
    float depth = -VERTEX.z; // Negative Z is towards camera in Godot

    // Calculate alpha based on depth
    float alpha = clamp(depth / transparency_depth, 0.0, 1.0);

    // Set the albedo (base color) and alpha
    ALBEDO = water_color.rgb;
    ALPHA = alpha;

    // Simple cartoon look with no complex lighting
    METALLIC = 0.0;
    ROUGHNESS = 1.0;
    SPECULAR = 0.0;
}

void vertex() {
    // No vertex modifications needed for this simple version
}