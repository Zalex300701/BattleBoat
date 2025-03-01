extends Node3D

@export var cannonball_scene: PackedScene

# Player movement variables
var max_forward_speed: float = 5.0
var max_backward_speed: float = 2.0
var acceleration: float = 2.0
var deceleration: float = 1.5
var current_speed: float = 0.0

# Player rotation variables
var max_turn_speed: float = 0.5
var turn_acceleration: float = 1.0
var turn_deceleration: float = 0.6
var current_turn_speed: float = 0.0

# Buoyancy variables
var bobbing_amplitude: float = 0.2 # Height variation
var bobbing_speed: float = 2.0
var rotation_amplitude: float = 2.0
var rotation_speed: float = 1.5
var initial_y: float
var initial_rotation: Vector3

# Maximum roll angle when turning
var max_turn_tilt: float = 5.0
var tilt_angle: float = 0.0
var tilt_smoothness: float = 3.0

func _ready():
	initial_y = position.y
	initial_rotation = rotation_degrees

func _physics_process(delta):
	handle_position_player(delta)
	handle_rotation_player(delta)
	apply_buoyancy(delta)

func apply_buoyancy(delta):
	# Vertical movement
	position.y = initial_y + sin(Time.get_ticks_msec() * 0.001 * bobbing_speed) * bobbing_amplitude
	
	# Roll and pitch
	var roll = sin(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	var pitch = cos(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	
	rotation_degrees.x = initial_rotation.x + roll
	rotation_degrees.z = initial_rotation.z + pitch + tilt_angle
	
func _input(event: InputEvent):
	# Shoot
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		shoot()

func handle_position_player(delta):
	# Default speed when no input
	var target_speed = 0.0
	
	if Input.is_action_pressed("move_forward"):
		target_speed = max_forward_speed
	elif Input.is_action_pressed("move_backward"):
		target_speed = -max_backward_speed
	
	# Smooth position acceleration/deceleration
	if current_speed < target_speed:
		current_speed += acceleration * delta
	elif current_speed > target_speed:
		current_speed -= deceleration * delta
	
	# Apply movement
	position += transform.basis.z * current_speed * delta

func handle_rotation_player(delta):
	# Default turn speed when no input
	var target_turn_speed = 0.0
	
	if Input.is_action_pressed("turn_left"):
		target_turn_speed = max_turn_speed
	elif Input.is_action_pressed("turn_right"):
		target_turn_speed = -max_turn_speed
	
	# Smooth rotation acceleration/deceleration
	if current_turn_speed < target_turn_speed:
		current_turn_speed += turn_acceleration * delta
	elif current_turn_speed > target_turn_speed:
		current_turn_speed -= turn_deceleration * delta
	
	# Apply rotation
	rotate_y(current_turn_speed * delta)
	
	# Apply roll tilt based on turn speed
	var target_tilt = (current_turn_speed / max_turn_speed) * max_turn_tilt
	tilt_angle = lerp(tilt_angle, target_tilt, delta * tilt_smoothness)

func shoot():
	if cannonball_scene:
		# Get the cannon markers
		var left_marker = $left_cannon/left_cannonball_spawn
		var right_marker = $right_cannon/right_cannonball_spawn
		
		if left_marker and right_marker:
			var left_cannonball = cannonball_scene.instantiate()
			var right_cannonball = cannonball_scene.instantiate()
			
			get_parent().add_child(left_cannonball)
			get_parent().add_child(right_cannonball)
			
			# Set position to marker
			left_cannonball.global_transform.origin = left_marker.global_transform.origin
			right_cannonball.global_transform.origin = right_marker.global_transform.origin
			
			# Apply force if it's a RigidBody3D
			var direction = -global_transform.basis.x.normalized()
			var speed = 50
			
			if left_cannonball is RigidBody3D:
				left_cannonball.linear_velocity = -direction * speed
			if right_cannonball is RigidBody3D:
				right_cannonball.linear_velocity = direction * speed
