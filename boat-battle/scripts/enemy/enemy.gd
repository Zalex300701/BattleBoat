extends CharacterBody3D

@export var WanderSpeed: float = 1.5
@export var RunSpeed: float = 2.5
@export var ChaseDistance: float = 100.0
@export var AttackDistance: float = 50.0
@export var RotationSpeed: float = 0.5
@export var CannonballSpeed: float = 50.0
@export var CannonCooldown: float = 3.0

var max_health: int = 3
var current_health: int = max_health

var player: CharacterBody3D = null

@onready var state_machine = $StateMachine

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	update_health_bar()

func _physics_process(_delta: float) -> void:
	move_and_slide()
	debug_lines()

func take_damage():
	current_health -= 1
	update_health_bar()
	if current_health <= 0:
		die()

func update_health_bar():
	var health_bar = $SubViewport/Panel/ProgressBar
	health_bar.value = float(current_health) / max_health * 100

func die():
	state_machine.on_child_transitioned(state_machine.current_state, "EnemyDying")

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
