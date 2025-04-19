extends Node3D

var can_shoot: bool = true
var shoot_cooldown: float = 1.0
var current_cooldown: float = 0.0
var cannonball_scene = load("res://scenes/cannonball.tscn")

func _ready() -> void:
	var left_cannon_marker = $left_cannon/left_cannon_marker
	var right_cannon_marker = $right_cannon/right_cannon_marker

func _process(delta: float) -> void:
	if not can_shoot:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_shoot = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and can_shoot:
		if event.keycode == KEY_A:
			shoot_left()
			start_cooldown()
		elif event.keycode == KEY_D:
			shoot_right()
			start_cooldown()

func start_cooldown() -> void:
	can_shoot = false
	current_cooldown = shoot_cooldown

func shoot_left():
	print("Player is shooting left")
func shoot_right():
	print("Player is shooting right")
