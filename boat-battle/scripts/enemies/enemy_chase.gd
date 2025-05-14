extends State
class_name EnemyChase

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func process(_delta: float):
	if get_parent().get_parent().is_in_group("Enemy_Medium"):
		if enemy.global_position.distance_to(player.global_position) < enemy.AttackDistance:
			emit_signal("Transitioned", self, "EnemyAttack")
	if get_parent().get_parent().is_in_group("Enemy_Bomber"):
		if enemy.global_position.distance_to(player.global_position) < enemy.ExplodeDistance:
			emit_signal("Transitioned", self, "EnemyExplode")
	
	if enemy.global_position.distance_to(player.global_position) > enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyWander")

func physics_process(delta: float) -> void:
	var direction = (player.global_position - enemy.global_position).normalized()
	direction.y = 0
	
	if direction.length() > 0:
		enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(-direction.x, -direction.z), delta * enemy.RotationSpeed)
	
	enemy.velocity = direction * enemy.RunSpeed
	
