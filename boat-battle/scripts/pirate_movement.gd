extends CharacterBody3D

@export var player: Node3D
@export var max_health: int = 3
@export var cannonball_scene: PackedScene
@export var explosion_scene: PackedScene

# Movement variables
var max_speed: float = 2.5
var acceleration: float = 1.5
var deceleration: float = 1.0
var current_speed:float = 0.0
var turn_speed: float = 1.0

# Firing variables
var firing_range: float = 40.0
var min_range: float = 5.0
var shoot_cooldown: float = 1.5
var current_cooldown: float = 0.0
var can_shoot: bool = true

# Other parameters
var current_health: int = max_health
var trigger_range: float = 100.0

func _ready():
	$ship_pirate_medium.rotate_y(deg_to_rad(180))
	update_health_bar()

func _physics_process(delta):
	if not player:
		return
	
	# Update shooting cooldown
	if not can_shoot:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_shoot = true
	
	# Calculate direction and distance to player
	var to_player = player.global_transform.origin - global_transform.origin
	var distance = to_player.length()
	to_player.y = 0 # Keep it on the horizontal plane
	var direction = to_player.normalized()
	
	# Decide behavior based on distance
	if distance > firing_range:
		approach_player(delta, direction)
	elif distance < min_range:
		retreat_from_player(delta, direction)
	else:
		align_for_firing(delta, direction)
	
	# Apply movement
	velocity = velocity.lerp(velocity, deceleration * delta) # Smooth stopping
	move_and_slide()

func _process(_delta):
	# Optimization: Disable physics when far from player
	if global_transform.origin.distance_to(player.global_transform.origin) > trigger_range:
		set_physics_process(false)
	else:
		set_physics_process(true)

func approach_player(delta: float, direction: Vector3):
	current_speed = min(current_speed + acceleration * delta, max_speed)
	velocity = direction * current_speed
	var target_basis = global_transform.looking_at(player.global_transform.origin, Vector3.UP).basis
	global_transform.basis = global_transform.basis.slerp(target_basis, turn_speed * delta)

func retreat_from_player(delta: float, direction: Vector3):
	current_speed = min(current_speed + acceleration * delta, max_speed)
	velocity = -direction * current_speed
	var target_basis = global_transform.looking_at(global_transform.origin - direction, Vector3.UP).basis
	global_transform.basis = global_transform.basis.slerp(target_basis, turn_speed * delta)

func align_for_firing(delta: float, direction: Vector3):
	current_speed = max(current_speed - deceleration * delta, 0.0)
	
	# Align side cannons (90° or -90°)
	var right_side = global_transform.basis.x.normalized()
	var left_side = -right_side
	var dot_right = right_side.dot(direction)
	var dot_left = left_side.dot(direction)
	
	# Choose the side facing the player
	var target_side = right_side if dot_right > dot_left else left_side
	var target_basis = Basis.looking_at(target_side.cross(Vector3.UP), Vector3.UP)
	global_transform.basis = global_transform.basis.slerp(target_basis, turn_speed * delta)
	
	# Fire when aligned
	var alignment = target_side.dot(direction)
	if abs(alignment) > 0.95 and can_shoot: # 95% aligned
		shoot(direction, target_side)

func shoot(player_direction: Vector3, firing_side: Vector3):
	if not cannonball_scene or not explosion_scene:
		return
	
	# Start cooldown
	can_shoot = false
	current_cooldown = shoot_cooldown
	
	# Choose cannon spawn point based on firing side
	var cannon_spawn = $right_cannon/right_cannonball_spawn if firing_side == global_transform.basis.x else $left_cannon/left_cannonball_spawn
	
	if cannon_spawn:
		# Spawn cannonball
		var cannonball = cannonball_scene.instantiate()
		get_parent().add_child(cannonball)
		
		# Position cannonball
		cannonball.global_transform.origin = cannon_spawn.global_transform.origin
		
		# Fire toward player
		var speed = 50 # Match player's cannonball speed
		if cannonball is Area3D:
			cannonball.launch(player_direction, speed)
		
		# Add explosion effect
		var explosion = explosion_scene.instantiate()
		explosion.global_transform.origin = cannon_spawn.global_transform.origin
		explosion.rotation = rotation if firing_side == global_transform.basis.x else rotation + Vector3(0, deg_to_rad(180), 0)
		get_parent().add_child(explosion)
		explosion.cannon_explosion()

# Handle being hit by cannonball
func take_damage():
	current_health -= 1
	print("Enemy hit! Health:", current_health)
	
	update_health_bar()
	
	if current_health <= 0:
		die()

# Update UI health bar above enemy
func update_health_bar():
	var health_bar = $SubViewport/Panel/ProgressBar
	health_bar.value = float(current_health) / max_health * 100  # Set percentage

func die():
	print("Enemy destroyed!")
	var explosion_instance = explosion_scene.instantiate()

	# Set the explosion's position to the explosion_marker position
	var explosion_marker = $explosion_marker  # Make sure the node path is correct
	explosion_instance.global_transform.origin = explosion_marker.global_transform.origin

	# Add it to the scene
	get_parent().add_child(explosion_instance)
	
	# Call the explosion's explode method	
	explosion_instance.die_explosion()

	# Remove the enemy
	queue_free()
