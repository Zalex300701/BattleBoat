extends State
class_name EnemyExplode

@onready var enemy: CharacterBody3D = get_parent().get_parent()

var current_cooldown: float = 0.0
var can_explode: bool = true

func _ready() -> void:
	pass

func process(delta: float) -> void:
	current_cooldown -= delta
	if current_cooldown <= 0:
		explode()
		can_explode = false

func physics_process(delta: float) -> void:
	# Lower forward movement at wander speed
	var forward_direction = -enemy.global_transform.basis.z.normalized()  # Forward is -Z in Godot
	enemy.velocity = forward_direction * enemy.WanderSpeed

func explode(damage: float = 5.0, radius: float = 20.0) -> void:
	if can_explode:
		var origin = enemy.global_transform.origin

		for group_name in ["Player", "Enemies"]:
			for node in get_tree().get_nodes_in_group(group_name):
				if node == enemy:
					continue  # Skip self
				if not node.has_method("take_damage"):
					continue  # Not a valid target

				var distance = origin.distance_to(node.global_transform.origin)
				if distance <= radius:
					node.take_damage(damage)
