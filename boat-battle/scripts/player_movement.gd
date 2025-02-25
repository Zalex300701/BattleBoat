extends Node3D

@export var cannonball_scene: PackedScene

# Movement variables
var max_forward_speed: float = 5.0
var max_backward_speed: float = 2.0
var acceleration: float = 2.0
var deceleration: float = 1.5
var current_speed: float = 0.0

# Rotation variables
var max_turn_speed: float = 0.5
var turn_acceleration: float = 1.0
var turn_deceleration: float = 0.6
var current_turn_speed: float = 0.0

func _physics_process(delta):
	handle_position(delta)
	handle_rotation(delta)
	
func _input(event: InputEvent):
	# Shoot
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		shoot()

func handle_position(delta):
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

func handle_rotation(delta):
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

# TO CLEAN

func shoot():
	if cannonball_scene:
		var left_cannonball = cannonball_scene.instantiate()
		var right_cannonball = cannonball_scene.instantiate()
		get_parent().add_child(left_cannonball)
		get_parent().add_child(right_cannonball)
		
		# Set position
		left_cannonball.global_transform.origin = global_transform.origin + Vector3(0,3,0)
		right_cannonball.global_transform.origin = global_transform.origin + Vector3(0,3,0)
		
		# Apply force if it's a RigidBody3D
		var direction = global_transform.basis.x.normalized()
		var speed = 50
		if left_cannonball is RigidBody3D:
			left_cannonball.linear_velocity = -direction * speed
		if right_cannonball is RigidBody3D:
			right_cannonball.linear_velocity = direction * speed
