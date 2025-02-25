extends Camera3D

# Min for scroll control
var min_fov = 45.0
var min_height = 80.0
var min_distance_from_player = 25.0
var min_rotation_x = -70.0
# Max for scroll control
var max_fov = 80.0
var max_height = 15.0
var max_distance_from_player = 12.0
var max_rotation_x = -30.0

var scroll_sensitivity = 0.035
var zoom_level = 0.25 # Value between 0 and 1 (0 = min, 1 = max)

@onready var player: Node3D = get_node("/root/Game/Player") 

func _ready() -> void:
	update_camera_position()

func _process(delta: float) -> void:
	update_camera_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_level = clamp(zoom_level + scroll_sensitivity, 0.0, 1.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_level = clamp(zoom_level - scroll_sensitivity, 0.0, 1.0)
		update_camera_position()

func smooth_step(t: float):
	return t * t * (3.0 - 2.0 * t)

func ease_in_quad(t: float):
	return t * t

func update_camera_position():
	var eased_zoom = smooth_step(zoom_level)
	var eased_in_quad_zoom = ease_in_quad(zoom_level)
	
	var current_fov = lerp(min_fov, max_fov, eased_zoom)
	var current_height = lerp(min_height, max_height, zoom_level)
	var current_distance_from_player = lerp(min_distance_from_player, max_distance_from_player, eased_in_quad_zoom)
	var current_rotation_x = lerp(min_rotation_x, max_rotation_x, eased_zoom)
	
	fov = current_fov
	position = player.global_transform.origin + Vector3(0, current_height, current_distance_from_player)
	rotation_degrees.x = current_rotation_x
