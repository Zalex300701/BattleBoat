extends CharacterBody3D

# Buoyancy variables
var bobbing_amplitude: float = 0.2 # Height variation
var bobbing_speed: float = 2.0
var rotation_amplitude: float = 2.0
var rotation_speed: float = 1.5
var initial_y: float
var initial_rotation: Vector3

func _ready():
	initial_y = global_transform.origin.y
	initial_rotation = rotation_degrees

func _physics_process(delta):
	apply_buoyancy(delta)

func apply_buoyancy(delta):
	# Vertical bobbing (apply as part of velocity)
	var bobbing_offset = sin(Time.get_ticks_msec() * 0.001 * bobbing_speed) * bobbing_amplitude
	velocity.y = (initial_y + bobbing_offset - global_transform.origin.y) / delta
	
	# Roll and pitch
	var roll = sin(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	var pitch = cos(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	
	rotation_degrees.x = initial_rotation.x + roll
	rotation_degrees.z = initial_rotation.z + pitch
