extends Node

@onready var player = $"../Environment/Player"

func _on_start_pressed():
	if player and player.has_method("leave_and_start"):
		player.leave_and_start("res://scenes/game.tscn")
