extends Node3D

@onready var player: CharacterBody3D = get_owner()
var can_shoot: bool = true
var shoot_cooldown: float = 3.0
var current_cooldown: float = 0.0
var cannonball_scene = load("res://scenes/cannonball.tscn")
var explosion_scene = load("res://scenes/explosion.tscn")

@onready var left_cannon_marker = $left_cannon/left_cannon_marker
@onready var right_cannon_marker = $right_cannon/right_cannon_marker
@onready var sfx_cannon: AudioStreamPlayer3D = $sfx_cannon

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not can_shoot:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_shoot = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and can_shoot:
		if event.keycode == KEY_Q:
			shoot(-1)
			start_cooldown()
		elif event.keycode == KEY_E:
			shoot(1)
			start_cooldown()

func start_cooldown() -> void:
	can_shoot = false
	current_cooldown = shoot_cooldown

func shoot(direction: int) -> void:
	sfx_cannon.play()
	var marker = right_cannon_marker if direction > 0 else left_cannon_marker
	var cannonball = cannonball_scene.instantiate()
	get_tree().root.add_child(cannonball)
	cannonball.global_transform.origin = marker.global_transform.origin
	var shoot_direction = global_transform.basis.x.normalized() * direction
	var speed = 50
	cannonball.launch(shoot_direction, speed, player)
	
	# Spawn explosion effect
	var explosion = explosion_scene.instantiate()
	get_parent().add_child(explosion)
	explosion.global_transform.origin = cannonball.global_transform.origin
	explosion.cannon_explosion()
	explosion.rotation = rotation if direction > 0 else rotation + Vector3(0, deg_to_rad(180), 0)
