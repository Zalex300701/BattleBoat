extends CharacterBody3D

# Buoyancy variables
var bobbing_amplitude: float = 0.2
var bobbing_speed: float = 2.0
var rotation_amplitude: float = 2.0
var rotation_speed: float = 1.5
var initial_y: float
var initial_rotation: Vector3

# Transition
var is_leaving := false
var leave_speed := 3.0
var leave_direction := Vector3.FORWARD
var scene_to_load := "res://scenes/game.tscn"

func _ready():
	initial_y = global_transform.origin.y
	initial_rotation = rotation_degrees

func _physics_process(delta):
	apply_buoyancy(delta)

	if is_leaving:
		position += -global_transform.basis.z * leave_speed * delta  # Move forward
		if global_transform.origin.z > 50:  # or whatever "out of frame" means
			get_tree().change_scene_to_file(scene_to_load)

func apply_buoyancy(delta):
	if is_leaving:
		return  # Optional: stop bobbing while leaving

	var bobbing_offset = sin(Time.get_ticks_msec() * 0.001 * bobbing_speed) * bobbing_amplitude
	velocity.y = (initial_y + bobbing_offset - global_transform.origin.y) / delta

	var roll = sin(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	var pitch = cos(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	
	rotation_degrees.x = initial_rotation.x + roll
	rotation_degrees.z = initial_rotation.z + pitch

func leave_and_start(scene_path: String):
	is_leaving = true
	scene_to_load = scene_path
