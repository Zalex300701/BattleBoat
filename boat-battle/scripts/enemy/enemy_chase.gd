extends State
class_name EnemyChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func process(_delta: float):
	if enemy.global_position.distance_to(player.global_position) > enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyWander")

func physics_process(_delta: float) -> void:
	enemy.look_at(Vector3(player.global_position.x, enemy.global_position.y, player.global_position.z))
	enemy.velocity = (player.global_transform.origin - enemy.global_transform.origin).normalized() * enemy.RunSpeed
