extends Node

@onready var player = $"../Environment/Player"

func _on_start_pressed():
	if player and player.has_method("leave_and_start"):
		player.leave_and_start("res://scenes/game.tscn")

func _on_boathouse_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	pass # Replace with function body.
