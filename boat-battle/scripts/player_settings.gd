extends Node

var current_sail_skin: String = "sail_white"

# Save chosen skin
func set_sail_skin(skin: String) -> void:
	current_sail_skin = skin
	# Sauvegarder dans un fichier pour persistance entre sessions
	#save_to_file()

# Load chosen skin
func get_sail_skin() -> String:
	return current_sail_skin

# Save chosen skin in a file (even if game close)
func save_to_file() -> void:
	var file = FileAccess.open("user://player_settings.save", FileAccess.WRITE)
	if file:
		file.store_string(current_sail_skin)
		file.close()

#Load chosen skin from a file
func load_from_file() -> void:
	if FileAccess.file_exists("user://player_settings.save"):
		var file = FileAccess.open("user://player_settings.save", FileAccess.READ)
		if file:
			current_sail_skin = file.get_as_text()
			file.close()
