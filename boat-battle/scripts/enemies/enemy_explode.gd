extends State
class_name EnemyExplode

@onready var enemy: CharacterBody3D = get_parent().get_parent()

var explosion_scene = load("res://scenes/explosion.tscn")

var explosion_cooldown: float = 3.5
var can_explode: bool = true

@onready var indicator = $"../../ExplosionIndicator"

func _ready():
	# Set size to match explosion radius (Decal extents, so half-size)
	var radius: float = 20.0
	indicator.extents = Vector3(radius, 1.0, radius)  # Y = height of projection box
	indicator.visible = false

func process(delta: float) -> void:
	indicator.visible = true
	explosion_cooldown -= delta
	if explosion_cooldown <= 0:
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
		
		# Spawn explosion effect
		var explosion = explosion_scene.instantiate()
		get_parent().add_child(explosion)
		var explosion_spawn = $"../../explosion_marker"
		explosion.global_transform.origin = explosion_spawn.global_transform.origin
		explosion.cannon_explosion()
		
		enemy.queue_free()
