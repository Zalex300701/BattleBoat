extends State
class_name EnemyWander

var wander_direction: Vector3
var wander_time: float = 0.0

@onready var enemy: CharacterBody3D = get_parent().get_parent()
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func randomize_variables():
	wander_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
	wander_time = randf_range(5.0, 20.0)

func enter():
	randomize_variables()

func process(delta: float):
	if wander_time < 0.0:
		randomize_variables()
	
	wander_time -= delta
	
	if enemy.global_position.distance_to(player.global_position) < enemy.ChaseDistance:
		emit_signal("Transitioned", self, "EnemyChase")
	
	if wander_direction.length() > 0:  # Ensure there's a direction to rotate toward
		var target_rotation = atan2(-wander_direction.x, -wander_direction.z)
		enemy.rotation.y = lerp_angle(enemy.rotation.y, target_rotation, delta * enemy.rotation_speed)

func physics_process(_delta: float):
	enemy.velocity = wander_direction * enemy.WanderSpeed
