extends CharacterBody3D

@export var WanderSpeed: float = 1.5
@export var RunSpeed: float = 3.0
@export var ChaseDistance: float = 80.0

var rotation_speed: float = 1.0

var max_health: int = 3
var current_health: int = max_health

var player: CharacterBody3D = null

@onready var state_machine = $StateMachine

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	update_health_bar()

func _physics_process(_delta: float) -> void:
	move_and_slide()

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
