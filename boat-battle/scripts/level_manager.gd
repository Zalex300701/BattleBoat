extends Node
class_name LevelManager

signal level_completed

var enemies_alive = 0
var elapsed_time = 0.0

var level_complete_ui_scene: PackedScene = load("res://scenes/ui/level_complete.tscn")
@export var current_level: int = 1

var level_complete_ui_instance = null

func _ready():
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemies_alive += 1
		enemy.died.connect(_on_enemy_died)
	get_tree().paused = false

func _process(delta):
	if not get_tree().paused:
		elapsed_time += delta

func _on_enemy_died():
	enemies_alive -= 1
	if enemies_alive <= 0:
		complete_level()

func complete_level():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Update the highest unlocked level in PlayerSettings
	if current_level + 1 > PlayerSettings.get_highest_unlocked_level() and current_level < 24:
		PlayerSettings.set_highest_unlocked_level(current_level + 1)
	
	level_complete_ui_instance = level_complete_ui_scene.instantiate()
	add_child(level_complete_ui_instance)
	
	level_complete_ui_instance.set_level_time(elapsed_time)
	level_complete_ui_instance.next_level_pressed.connect(_on_next_level_pressed)
	level_complete_ui_instance.menu_pressed.connect(_on_menu_pressed)

func _on_next_level_pressed():
	# Unpause and transition to the next level
	get_tree().paused = false
	var next_level = current_level + 1
	if next_level <= 24: # Assuming 24 levels
		SceneTransition.change_scene("res://scenes/levels/level" + str(next_level) + ".tscn")
	else:
		# If no more levels, go to menu
		SceneTransition.change_scene("res://scenes/levels/game_menu.tscn")

func _on_menu_pressed():
	# Unpause and return to level select menu
	get_tree().paused = false
	SceneTransition.change_scene("res://scenes/levels/game_menu.tscn")
