extends State
class_name EnemyAttack

@onready var enemy: CharacterBody3D = get_parent().get_parent()

var cannonball_scene = load("res://scenes/cannonball.tscn")
var explosion_scene = load("res://scenes/explosion.tscn")

var player: CharacterBody3D = null

var can_shoot: bool = true
var current_cooldown: float = 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func process(_delta: float) -> void:
	if enemy.global_position.distance_to(player.global_position) > enemy.AttackDistance:
		emit_signal("Transitioned", self, "EnemyChase")

func physics_process(delta: float) -> void:
	var to_player = (player.global_transform.origin - enemy.global_transform.origin).normalized()
	to_player.y = 0
	align_for_firing(delta, to_player)
	
	# Maintain forward movement at chase speed
	var forward_direction = -enemy.global_transform.basis.z.normalized()  # Forward is -Z in Godot
	enemy.velocity = forward_direction * enemy.RunSpeed
	
	# Update cannon cooldown
	if not can_shoot:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_shoot = true

func align_for_firing(delta: float, direction: Vector3):
	# Get the enemy's right and left side vectors
	var right_side = enemy.global_transform.basis.x.normalized()  # Local +X axis (right)
	var left_side = -right_side  # Local -X axis (left)

	# Calculate dot products to determine which side is closer to facing the player
	var dot_right = right_side.dot(direction)
	var dot_left = left_side.dot(direction)

	# Choose the side that requires the least rotation to face the player
	var target_side = right_side if dot_right > dot_left else left_side
	var firing_right_side = true if target_side == right_side else false

	# Calculate the target rotation for broadside alignment
	var player_rotation = atan2(-direction.x, -direction.z)
	var target_rotation = player_rotation + (PI / 2 if target_side == right_side else -PI / 2)

	# Smoothly interpolate the enemy's rotation toward the target
	enemy.rotation.y = lerp_angle(enemy.rotation.y, target_rotation, delta * enemy.RotationSpeed)

	# Check if the enemy is aligned well enough to fire
	var angle_diff = abs(wrapf(enemy.rotation.y - target_rotation, -PI, PI))
	if angle_diff < 0.2 and can_shoot:  # Adjust threshold for firing (wider tolerance for continuous firing)
		fire_cannons(direction, firing_right_side)

func fire_cannons(player_direction: Vector3, firing_right_side: bool):
	# Cooldown
	can_shoot = false
	current_cooldown = enemy.CannonCooldown
	
	# Spawn cannonball
	var cannon_spawn = $"../../ship_model/right_cannon/right_cannonball_spawn" if firing_right_side else $"../../ship_model/left_cannon/left_cannonball_spawn"
	var cannonball = cannonball_scene.instantiate()
	get_parent().add_child(cannonball)
	cannonball.global_transform.origin = cannon_spawn.global_transform.origin
	
	# Fire toward player
	cannonball.launch(player_direction, enemy.CannonballSpeed, enemy)
	
	# Spawn explosion effect
	var explosion = explosion_scene.instantiate()
	get_parent().add_child(explosion)
	explosion.global_transform.origin = cannon_spawn.global_transform.origin
	explosion.cannon_explosion()
	explosion.rotation = enemy.rotation if firing_right_side else enemy.rotation + Vector3(0, deg_to_rad(180), 0)
