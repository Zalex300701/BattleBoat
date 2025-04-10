extends State
class_name EnemyAttack

@onready var enemy: CharacterBody3D = get_parent().get_parent()

var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func process(delta: float) -> void:
	if enemy.global_position.distance_to(player.global_position) > enemy.AttackDistance:
		emit_signal("Transitioned", self, "EnemyChase")

func physics_process(delta: float) -> void:
	var to_player = player.global_transform.origin - enemy.global_transform.origin
	to_player.y = 0
	var direction = to_player.normalized()
	
	align_for_firing(delta, direction)

func align_for_firing(delta: float, direction: Vector3):
	var right_side = enemy.global_transform.basis.x.normalized()
	var left_side = -right_side
	var dot_right = right_side.dot(direction)
	var dot_left = left_side.dot(direction)
	
	var target_side = right_side if dot_right > dot_left else left_side
	
	enemy.velocity = target_side * enemy.RunSpeed
