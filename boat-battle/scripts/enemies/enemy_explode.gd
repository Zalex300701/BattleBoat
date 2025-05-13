extends State
class_name EnemyExplode

@onready var enemy: CharacterBody3D = get_parent().get_parent()

var explosion_scene = load("res://scenes/explosion.tscn")

var explosion_cooldown: float = 3.5
var can_explode: bool = true

@onready var ship_model: MeshInstance3D = $"../../ship_model"

func _ready():
	# Set size to match explosion radius (Decal extents, so half-size)
	var radius: float = 20.0

func process(delta: float) -> void:
	explosion_cooldown -= delta
	if explosion_cooldown <= 0:
		explode()
		can_explode = false

func physics_process(_delta: float) -> void:
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
				
				var distance = origin.distance_to(node.global_transform.origin)
				if distance <= radius:
					if node.has_method("take_damage"):
					# Apply damage to all valid targets
						node.take_damage(damage)
					if node.has_method("chained_reaction"):
					# Chain reaction if other bombers
						node.chained_reaction(damage, radius)
		
		# Spawn explosion effect
		var explosion = explosion_scene.instantiate()
		get_parent().add_child(explosion)
		var explosion_spawn = $"../../explosion_marker"
		explosion.global_transform.origin = explosion_spawn.global_transform.origin
		explosion.die_explosion()
		
		# Hide ship model
		ship_model.hide()
		
		# Wait animations before deletion
		await get_tree().create_timer(2.0).timeout 
		enemy.queue_free()
