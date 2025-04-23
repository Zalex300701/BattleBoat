extends Node
class_name LevelManager

# Signal to notify when the level is complete
signal level_completed

# Track enemies
var enemies_alive = 0

# Reference to the Level Complete UI scene (set in the editor or loaded)
var level_complete_ui_scene: PackedScene = load("res://scenes/ui/level_complete.tscn")
@export var current_level: int = 1 # Set this in the editor for each level (1 to 24)

var level_complete_ui_instance = null

func _ready():
	# Find all enemies in the scene
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemies_alive += 1
		enemy.died.connect(_on_enemy_died)
	
	# Ensure the game is not paused initially
	get_tree().paused = false

func _on_enemy_died():
	enemies_alive -= 1
	if enemies_alive <= 0:
		# Win condition met
		complete_level()

func complete_level():
	# Pause the game
	get_tree().paused = true
	
	# Ensure mouse cursor is visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	level_complete_ui_instance = level_complete_ui_scene.instantiate()
	add_child(level_complete_ui_instance)
	# Connect UI signals (assuming the UI emits signals for button presses)
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
	print("yes")
	SceneTransition.change_scene("res://scenes/levels/game_menu.tscn")
