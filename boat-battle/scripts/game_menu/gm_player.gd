extends CharacterBody3D

# Buoyancy settings
var bobbing_amplitude: float = 0.2
var bobbing_speed: float = 2.0
var rotation_amplitude: float = 2.0
var rotation_speed: float = 1.5
var initial_y: float
var initial_rotation: Vector3

# Departure settings
var is_leaving := false
var leave_speed: float = 10.0
var scene_to_load: String = "res://scenes/game.tscn"
var exit_z_threshold: float = -10.0
var current_speed: float = 0.0
var acceleration_duration: float = 2.5
var departure_time: float = 0.0
var has_transitioned: bool = false

func _ready() -> void:
	initial_y = global_transform.origin.y
	initial_rotation = rotation_degrees

func _physics_process(delta: float) -> void:
	apply_buoyancy(delta)
	if is_leaving:
		handle_departure(delta)

func apply_buoyancy(delta: float) -> void:
	var bobbing_offset = sin(Time.get_ticks_msec() * 0.001 * bobbing_speed) * bobbing_amplitude
	velocity.y = (initial_y + bobbing_offset - global_transform.origin.y) / delta

	var roll = sin(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	var pitch = cos(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	
	rotation_degrees.x = initial_rotation.x + roll
	rotation_degrees.z = initial_rotation.z + pitch

func handle_departure(delta: float) -> void:
	departure_time += delta

	# Smooth acceleration with quadratic ease-out
	var t = min(departure_time / acceleration_duration, 1.0)
	current_speed = lerp(0.0, leave_speed, 1.0 - pow(1.0 - t, 2))

	# Move ship forward
	position += -global_transform.basis.z * current_speed * delta

	# Check for scene transition
	if !has_transitioned and global_transform.origin.z < exit_z_threshold:
		has_transitioned = true
		SceneTransition.change_scene(scene_to_load)

func leave_and_start(scene_path: String) -> void:
	is_leaving = true
	scene_to_load = scene_path
