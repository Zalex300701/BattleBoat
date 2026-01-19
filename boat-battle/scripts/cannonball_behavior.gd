extends Area3D

@export var speed: float = 50.0
@export var fall_distance: float = 50.0 # Distance before gravity applies
@export var despawn_depth: float = -20.0
@onready var sfx_splash: AudioStreamPlayer3D = $sfx_splash
@onready var splash: GPUParticles3D = $Splash

var direction: Vector3 = Vector3.ZERO
var is_moving: bool = false
var fixed_y: float = 0.0  # Stores the initial Y position
var traveled_distance: float = 0.0 # Tracks how far the cannonball has moved
var falling: bool = false # Flag to indicate if it should fall
var target: Node3D = null  # Reference to the player for guided movement
var shooter: Node3D = null
var has_splashed: bool = false

func _process(delta):
	if is_moving:
		if target != null:  # Guided mode
			# Calculate direction toward the player's current position
			var player_pos = target.global_transform.origin
			player_pos.y = fixed_y  # Keep the Y position fixed
			direction = (player_pos - global_transform.origin).normalized()
			
			var move_vector = direction * speed * delta
			traveled_distance += move_vector.length()
			
			# Move cannonball to player
			global_transform.origin.x += move_vector.x
			global_transform.origin.z += move_vector.z
		else:
			var move_vector = direction * speed * delta
			traveled_distance += move_vector.length()
			
			# Move cannonball straight
			global_transform.origin.x += move_vector.x
			global_transform.origin.z += move_vector.z
		
		# Start falling after reaching the fall distance
		if traveled_distance >= fall_distance:
			falling = true
		
		# Apply falling logic
		if falling:
			global_transform.origin.y -= gravity * delta  # Simulate falling
		else:
			global_transform.origin.y = fixed_y  # Keep height constant
		
		# Splash sound
		if falling and global_transform.origin.y <= 0.0 and !has_splashed:
			has_splashed = true
			sfx_splash.play()
			splash.emitting = true
		
		# Despawn if it sinks too deep
		if global_transform.origin.y <= despawn_depth:
			queue_free()

func launch(dir: Vector3, spd: float, firing_owner: Node3D = null):
	$cannonball_classic.show()
	if has_node("CollisionShape_Classic"):
		$CollisionShape_Classic.disabled = false
	if has_node("CollisionShape_Ghost"):
		$CollisionShape_Ghost.disabled = true
	direction = dir
	speed = spd
	shooter = firing_owner
	fixed_y = global_transform.origin.y  # Store the Y position at launch
	is_moving = true

func launch_guided(spd: float, firing_owner: Node3D = null, player: Node3D = null):
	$cannonball_ghost.show()
	add_to_group("ghost")
	if has_node("CollisionShape_Ghost"):
		$CollisionShape_Ghost.disabled = false
	if has_node("CollisionShape_Classic"):
		$CollisionShape_Classic.disabled = true
	speed = spd
	shooter = firing_owner
	fixed_y = global_transform.origin.y  # Store the Y position at launch
	target = player  # Set the player as the target
	is_moving = true

func _on_body_entered(body):
	if body == shooter:
		return
	
	is_moving = false
	print("Cannonball hit:", body.name)
	
	# Check if the body is an enemy and if it has the take_damage method
	if body.has_method("take_damage") and !body.is_dying:
		
		# Load and instance the explosion scene
		var explosion_scene = preload("res://scenes/explosion.tscn")  # Adjust the path if needed
		var explosion_instance = explosion_scene.instantiate()
		
		# Set the damage's position to the point of impact between cannonball and enemy
		explosion_instance.global_transform.origin = self.global_transform.origin
		
		# Align the explosion's rotation with the cannonball's direction
		if direction != Vector3.ZERO:  # Ensure direction is valid
			var forward = direction.normalized()  # Normalize to get a unit vector
			explosion_instance.look_at(self.global_transform.origin + forward, Vector3.UP)
		
		# Add it to the scene
		get_parent().add_child(explosion_instance)
		
		# Call the explosion's damage method
		explosion_instance.damage()
		
		body.take_damage(1)
		
	queue_free()

func _on_area_entered(area):
	# Si c'est un ghost qui touche un classic
	if is_in_group("ghost") and area.has_node("cannonball_classic"):
		print("Ghost cannonball destroyed by classic cannonball!")
		queue_free()
