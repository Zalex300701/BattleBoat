extends CharacterBody3D

@export var player: Node3D

var max_speed = 3.0
var acceleration = 1.5
var deceleration = 1.0
var current_speed = 0.0
var turn_speed = 2.0

func _ready():
	$ship_pirate_medium.rotate_y(deg_to_rad(180))

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
