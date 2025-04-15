extends Node

@onready var player = $"../Environment/Player"
@onready var camera = $"../Camera3D"

func _on_start_pressed():
	if player and player.has_method("leave_and_start"):
		$Main_menu.hide()
		player.leave_and_start("res://scenes/game.tscn")

func _on_boathouse_button_pressed() -> void:
	if camera and camera.has_method("boathouse_position"):
		camera.boathouse_position()
		$Main_menu.hide()
		$Boathouse_menu.show()

func _on_back_boathouse_pressed() -> void:
	if camera and camera.has_method("main_position"):
		camera.main_position()
		$Main_menu.show()
		$Boathouse_menu.hide()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
