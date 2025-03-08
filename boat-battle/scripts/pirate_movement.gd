extends CharacterBody3D

@export var player: Node3D
@export var max_health: int = 3 # Enemy has 3 HP

var current_health: int = max_health
var max_speed = 3.0
var acceleration = 1.5
var deceleration = 1.0
var current_speed = 0.0
var turn_speed = 2.0

func _ready():
	$ship_pirate_medium.rotate_y(deg_to_rad(180))
	update_health_bar()

func _physics_process(delta):
	if not player:
		return
	move_towards_player(delta)

func move_towards_player(delta):
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	direction.y = 0  # Ignore la hauteur
	
	# Faire tourner l'ennemi vers le joueur
	var target_rotation = global_transform.looking_at(player.global_transform.origin, Vector3.UP).basis
	global_transform.basis = global_transform.basis.slerp(target_rotation, turn_speed * delta)

	# Gérer l'accélération progressive
	var target_speed = max_speed
	if current_speed < target_speed:
		current_speed += acceleration * delta
	elif current_speed > target_speed:
		current_speed -= deceleration * delta

	# Appliquer la vitesse
	velocity = -global_transform.basis.z * current_speed
	move_and_slide()
	
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
	
	# Load and instance the explosion scene
	var explosion_scene = preload("res://scenes/explosion.tscn")  # Adjust the path if needed
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
