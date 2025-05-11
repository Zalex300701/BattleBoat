extends CharacterBody3D

@export var WanderSpeed: float = 1.5
@export var RunSpeed: float = 2.5
@export var ChaseDistance: float = 100.0
@export var AttackDistance: float = 50.0
@export var RotationSpeed: float = 0.5
@export var CannonballSpeed: float = 50.0
@export var CannonCooldown: float = 3.0

# Buoyancy parameters
@export var bobbing_speed: float = 2.0
@export var bobbing_amplitude: float = 0.1
@export var rotation_speed: float = 1.5
@export var rotation_amplitude: float = 1.0

# Tilt parameters
@export var max_turn_tilt: float = 5.0  # Maximum roll angle when turning
@export var tilt_smoothness: float = 3.0  # How smoothly tilt adjusts

var max_health: int = 3
var current_health: int = max_health
var initial_y: float
var initial_rotation: Vector3
var tilt_angle: float = 0.0  # Current tilt angle
var last_rotation_y: float  # To calculate turn speed
var turn_speed: float = 0.0  # Current turn speed (radians/sec)
var is_dying: bool = false
signal died

var player: CharacterBody3D = null
@onready var state_machine = $StateMachine
@onready var ship_model = $ship_model
@onready var health_bar = $SubViewport/Panel/ProgressBar

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	update_health_bar()
	initial_y = global_transform.origin.y
	initial_rotation = rotation_degrees
	last_rotation_y = rotation.y  # Initialize last rotation

func _physics_process(delta: float) -> void:
	if state_machine.current_state.name != "EnemyDying":
		apply_buoyancy(delta)
		apply_turn_tilt(delta)
	move_and_slide()
	#debug_lines()

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

func take_damage(amount: int):
	current_health -= amount
	update_health_bar()
	if current_health <= 0:
		die()

func update_health_bar():
	health_bar.value = float(current_health) / max_health * 100

func die():
	is_dying = true
	state_machine.on_child_transitioned(state_machine.current_state, "EnemyDying")
	emit_signal("died")

func debug_lines():
	var to_player = player.global_transform.origin - global_transform.origin
	to_player.y = 0
	var direction = to_player.normalized()
	var right_side = global_transform.basis.x.normalized()
	var left_side = -right_side
	var dot_right = right_side.dot(direction)
	var dot_left = left_side.dot(direction)
	
	var target_side = right_side if dot_right > dot_left else left_side
	
	# Debug visualization
	var pos = global_position
	pos.y = 10.5
	DebugDraw3D.draw_line(pos, pos + right_side, Color(1, 0, 0)) # Red
	DebugDraw3D.draw_line(pos, pos + left_side, Color(0, 0, 1)) # Blue
	DebugDraw3D.draw_line(pos, pos + to_player, Color(0, 1, 0)) # Green
	DebugDraw3D.draw_line(pos, pos + target_side, Color(1, 1, 0)) # Yellow
