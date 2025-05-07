extends CharacterBody3D

@export var WanderSpeed: float = 1.5
@export var RunSpeed: float = 4.0
@export var ChaseDistance: float = 100.0
@export var ExplodeDistance: float = 10.0
@export var RotationSpeed: float = 4.0

# Buoyancy parameters
@export var bobbing_speed: float = 2.0
@export var bobbing_amplitude: float = 0.1
@export var rotation_speed: float = 1.5
@export var rotation_amplitude: float = 1.0

# Tilt parameters
@export var max_turn_tilt: float = 5.0  # Maximum roll angle when turning
@export var tilt_smoothness: float = 3.0  # How smoothly tilt adjusts

var initial_y: float
var initial_rotation: Vector3
var tilt_angle: float = 0.0  # Current tilt angle
var last_rotation_y: float  # To calculate turn speed
var turn_speed: float = 0.0  # Current turn speed (radians/sec)

var player: CharacterBody3D = null
@onready var state_machine = $StateMachine
@onready var ship_model = $ship_model

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	initial_y = global_transform.origin.y
	initial_rotation = rotation_degrees
	last_rotation_y = rotation.y

func _physics_process(delta: float) -> void:
	apply_buoyancy(delta)
	apply_turn_tilt(delta)
	move_and_slide()

func apply_buoyancy(delta: float):
	# Vertical bobbing
	var bobbing_offset = sin(Time.get_ticks_msec() * 0.001 * bobbing_speed) * bobbing_amplitude
	velocity.y = (initial_y + bobbing_offset - global_transform.origin.y) / delta
	
	# Roll and pitch from buoyancy
	var roll = sin(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	var pitch = cos(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	
	if ship_model:
		# Apply buoyancy roll/pitch + turn tilt to visual model
		ship_model.rotation_degrees.x = initial_rotation.x + roll 
		ship_model.rotation_degrees.z = initial_rotation.z + pitch + tilt_angle
	else:
		# Fallback to self, preserving yaw
		rotation_degrees.x = initial_rotation.x + roll
		rotation_degrees.z = initial_rotation.z + pitch + tilt_angle

func apply_turn_tilt(delta: float):
	# Calculate turn speed (radians/sec)
	var current_rotation_y = rotation.y
	turn_speed = (current_rotation_y - last_rotation_y) / delta
	last_rotation_y = current_rotation_y
	
	# Calculate target tilt based on turn speed
	var normalized_turn = clamp(turn_speed / RotationSpeed, -1.0, 1.0)
	var target_tilt = normalized_turn * max_turn_tilt
	
	# Smoothly adjust tilt
	tilt_angle = lerp(tilt_angle, target_tilt, delta * tilt_smoothness)
