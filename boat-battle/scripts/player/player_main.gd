extends CharacterBody3D

# Player movement variables
var max_forward_speed: float = 5.0
var max_backward_speed: float = 2.0
var acceleration: float = 2.0
var deceleration: float = 1.5
var current_speed: float = 0.0

# Player rotation variables
var max_turn_speed: float = 0.5
var turn_acceleration: float = 1.0
var turn_deceleration: float = 0.6
var current_turn_speed: float = 0.0

# Buoyancy variables
var bobbing_amplitude: float = 0.2 # Height variation
var bobbing_speed: float = 2.0
var rotation_amplitude: float = 2.0
var rotation_speed: float = 1.5
var initial_y: float
var initial_rotation: Vector3

# Maximum roll angle when turning
var max_turn_tilt: float = -5.0
var tilt_angle: float = 0.0
var tilt_smoothness: float = 3.0

# Health variables
@export var max_health: float = 10.0
var current_health: float = max_health
signal health_changed(new_health, max_health)
var has_initialized_health: bool = false

# Death variables
@onready var animation_player = $"AnimationPlayer"
var sink_animations := ["player_sink_1", "player_sink_2", "player_sink_3", "player_sink_4"]
var is_dying = false

@onready var sfx_wood_break: AudioStreamPlayer3D = $sfx_wood_break

func _ready():
	apply_sail_skin(PlayerSettings.get_sail_skin())
	apply_hull_skin(PlayerSettings.get_hull_skin())
	initial_y = global_transform.origin.y
	initial_rotation = rotation_degrees
	current_health = max_health
	is_dying = false

func _process(_delta):
	# Emit health_changed on the first frame after _ready
	if not has_initialized_health:
		emit_signal("health_changed", current_health, max_health)
		has_initialized_health = true

func _physics_process(delta):
	if !is_dying:
		handle_position_player(delta)
		handle_rotation_player(delta)
		apply_buoyancy(delta)

func apply_buoyancy(delta):
	# Vertical bobbing (apply as part of velocity)
	var bobbing_offset = sin(Time.get_ticks_msec() * 0.001 * bobbing_speed) * bobbing_amplitude
	velocity.y = (initial_y + bobbing_offset - global_transform.origin.y) / delta
	
	# Roll and pitch
	var roll = sin(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	var pitch = cos(Time.get_ticks_msec() * 0.001 * rotation_speed) * rotation_amplitude
	
	rotation_degrees.x = initial_rotation.x + roll
	rotation_degrees.z = initial_rotation.z + pitch + tilt_angle

func handle_position_player(delta):
	# Default speed when no input
	var target_speed = 0.0
	
	if Input.is_action_pressed("move_forward"):
		target_speed = -max_forward_speed # - Because boat points -Z
	elif Input.is_action_pressed("move_backward"):
		target_speed = max_backward_speed
	
	# Smooth position acceleration/deceleration
	if current_speed < target_speed:
		current_speed += acceleration * delta
	elif current_speed > target_speed:
		current_speed -= deceleration * delta
	
	# Apply movement with physics (along local Z-axis)
	velocity.x = transform.basis.z.x * current_speed
	velocity.z = transform.basis.z.z * current_speed
	move_and_slide()

func handle_rotation_player(delta):
	# Default turn speed when no input
	var target_turn_speed = 0.0
	
	if Input.is_action_pressed("turn_left"):
		target_turn_speed = max_turn_speed
	elif Input.is_action_pressed("turn_right"):
		target_turn_speed = -max_turn_speed
	
	# Smooth rotation acceleration/deceleration
	if current_turn_speed < target_turn_speed:
		current_turn_speed += turn_acceleration * delta
	elif current_turn_speed > target_turn_speed:
		current_turn_speed -= turn_deceleration * delta
	
	# Apply rotation
	rotate_y(current_turn_speed * delta)
	
	# Apply roll tilt based on turn speed
	var target_tilt = (current_turn_speed / max_turn_speed) * max_turn_tilt
	tilt_angle = lerp(tilt_angle, target_tilt, delta * tilt_smoothness)

func take_damage(amount: float):
	current_health = clamp(current_health - amount, 0, max_health)
	emit_signal("health_changed", current_health, max_health)
	if current_health <= 0:
		is_dying = true
		die()
	sfx_wood_break.play()

func heal(amount: float):
	current_health = clamp(current_health + amount, 0, max_health)
	emit_signal("health_changed", current_health, max_health)

func die():
	self.set_physics_process(false)
	$CollisionShape3D.disabled = true
	var chosen_animation = sink_animations[randi() % sink_animations.size()]
	animation_player.play(chosen_animation)
	await animation_player.animation_finished

func apply_sail_skin(sail_color: String) -> void:
	# Accéder à la MeshInstance3D de la voile (sail-1)
	var sail = get_node("ship_small/sail-1")
	if not sail or not sail is MeshInstance3D:
		print("Erreur : Voile non trouvée ou n'est pas une MeshInstance3D")
		return
	
	# Charger le modèle de la voile de la couleur choisie
	var sail_resource = load("res://assets/models/skins/sail/%s.glb" % sail_color)
	if not sail_resource:
		print("Erreur : Impossible de charger %s.glb" % sail_color)
		return
	
	# Instancier la scène pour accéder à son contenu
	var sail_instance = sail_resource.instantiate()
	
	# Trouver la MeshInstance3D dans le modèle chargé
	var sail_mesh = null
	for child in sail_instance.get_children():
		if child is MeshInstance3D:
			sail_mesh = child
			break
	
	if not sail_mesh:
		print("Erreur : Aucun MeshInstance3D trouvé dans %s.glb" % sail_color)
		return
	
	# Appliquer le mesh de la voile à sail-1
	sail.mesh = sail_mesh.mesh
	
	# Nettoyer l'instance pour éviter les fuites de mémoire
	sail_instance.queue_free()

func apply_hull_skin(hull_color: String) -> void:
	var hull = get_node("ship_small")
	if not hull or not hull is MeshInstance3D:
		print("Erreur : Coque non trouvée ou n'est pas une MeshInstance3D")
		return
	
	var hull_resource = load("res://assets/models/skins/hull/%s.glb" % hull_color)
	if not hull_resource:
		print("Erreur : Impossible de charger %s.glb" % hull_color)
		return
	
	var hull_instance = hull_resource.instantiate()
	var hull_mesh = null
	for child in hull_instance.get_children():
		if child is MeshInstance3D:
			hull_mesh = child
			break
	
	if not hull_mesh:
		print("Erreur : Aucun MeshInstance3D trouvé dans %s.glb" % hull_color)
		return
	
	hull.mesh = hull_mesh.mesh
	hull_instance.queue_free()
