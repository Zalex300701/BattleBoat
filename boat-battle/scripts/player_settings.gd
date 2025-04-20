extends Node

var current_sail_skin: String = "sail_white"
var current_hull_skin: String = "ship_small_hull_brown"

# Save chosen sail skin
func set_sail_skin(skin: String) -> void:
	current_sail_skin = skin
	save_to_file()

# Save chosen hull skin
func set_hull_skin(skin: String) -> void:
	current_hull_skin = skin
	save_to_file()

# Load chosen sail skin
func get_sail_skin() -> String:
	return current_sail_skin

# Load chosen hull skin
func get_hull_skin() -> String:
	return current_hull_skin

# Save chosen skins in a file (even if game close)
func save_to_file() -> void:
	var file = FileAccess.open("user://player_settings.save", FileAccess.WRITE)
	if file:
		var data = {
			"sail_skin": current_sail_skin,
			"hull_skin": current_hull_skin
		}
		file.store_string(JSON.stringify(data))
		file.close()

# Load chosen skins from a file
func load_from_file() -> void:
	if FileAccess.file_exists("user://player_settings.save"):
		var file = FileAccess.open("user://player_settings.save", FileAccess.READ)
		if file:
			var data = JSON.parse_string(file.get_as_text())
			current_sail_skin = data.get("sail_skin", "sail_white")
			current_hull_skin = data.get("hull_skin", "ship_small_hull_brown")
			file.close()
