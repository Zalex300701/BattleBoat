extends Node

@onready var player = $"../Environment/Player"
@onready var camera = $"../Camera3D"

func _on_start_pressed():
	if player and player.has_method("leave_and_start"):
		player.leave_and_start("res://scenes/game.tscn")

func _on_boathouse_button_pressed() -> void:
	if camera and camera.has_method("boathouse_position"):
		camera.boathouse_position()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
