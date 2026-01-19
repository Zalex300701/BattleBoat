extends Node

var highest_unlocked_level: int = 1
var current_sail_skin: String = "sail_white"
var current_hull_skin: String = "ship_small_hull_brown"
var max_health: int = 10
var current_health: int = 10

func _ready():
	load_from_file()  # Load settings when the game starts

# Save the highest unlocked level
func set_highest_unlocked_level(level: int) -> void:
	highest_unlocked_level = level
	save_to_file()

# Save chosen sail skin
func set_sail_skin(skin: String) -> void:
	current_sail_skin = skin
	save_to_file()

# Save chosen hull skin
func set_hull_skin(skin: String) -> void:
	current_hull_skin = skin
	save_to_file()

# Load the highest unlocked level
func get_highest_unlocked_level() -> int:
	return highest_unlocked_level

# Load chosen sail skin
func get_sail_skin() -> String:
	return current_sail_skin

# Load chosen hull skin
func get_hull_skin() -> String:
	return current_hull_skin

# Save chosen skins and level progress in a file
func save_to_file() -> void:
	var file = FileAccess.open("user://player_settings.save", FileAccess.WRITE)
	if file:
		var data = {
			"highest_unlocked_level": highest_unlocked_level,
			"sail_skin": current_sail_skin,
			"hull_skin": current_hull_skin
		}
		file.store_string(JSON.stringify(data))
		file.close()

# Load chosen skins and level progress from a file
func load_from_file() -> void:
	if FileAccess.file_exists("user://player_settings.save"):
		var file = FileAccess.open("user://player_settings.save", FileAccess.READ)
		if file:
			var data = JSON.parse_string(file.get_as_text())
			highest_unlocked_level = data.get("highest_unlocked_level", 1)  # Default to 1 if not found
			current_sail_skin = data.get("sail_skin", "sail_white")
			current_hull_skin = data.get("hull_skin", "ship_small_hull_brown")
			file.close()

func reset_progress() -> void:
	current_sail_skin = "sail_white"
	current_hull_skin = "ship_small_hull_brown"
	highest_unlocked_level = 1
	save_to_file()
