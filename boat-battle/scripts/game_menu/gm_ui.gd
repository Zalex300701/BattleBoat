extends Node

@onready var player = $"../Environment/Player"
@onready var camera = $"../Camera3D"

func _ready() -> void:
	# Load skins from file
	PlayerSettings.load_from_file()
	# Load saved skins
	apply_sail_skin(PlayerSettings.get_sail_skin())
	apply_hull_skin(PlayerSettings.get_hull_skin())

func _on_start_pressed():
	$Main_menu.hide()
	$Levels_menu.show()

func _on_boathouse_button_pressed() -> void:
	if camera and camera.has_method("boathouse_position"):
		camera.boathouse_position()
		$Main_menu.hide()
		$Boathouse_menu.show()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_back_levels_pressed() -> void:
	$Main_menu.show()
	$Levels_menu.hide()

func _on_back_boathouse_pressed() -> void:
	if camera and camera.has_method("main_position"):
		camera.main_position()
		$Main_menu.show()
		$Boathouse_menu.hide()

func _on_level_1_pressed() -> void:
	$Levels_menu.hide()
	player.leave_and_start("res://scenes/levels/level1.tscn")

func _on_sail_white_pressed() -> void:
	_on_sail_color_button_pressed("sail_white")

func _on_sail_grey_pressed() -> void:
	_on_sail_color_button_pressed("sail_grey")

func _on_sail_black_pressed() -> void:
	_on_sail_color_button_pressed("sail_black")

func _on_sail_yellow_pressed() -> void:
	_on_sail_color_button_pressed("sail_yellow")

func _on_sail_orange_pressed() -> void:
	_on_sail_color_button_pressed("sail_orange")

func _on_sail_red_pressed() -> void:
	_on_sail_color_button_pressed("sail_red")

func _on_sail_blue_pressed() -> void:
	_on_sail_color_button_pressed("sail_blue")

func _on_sail_green_pressed() -> void:
	_on_sail_color_button_pressed("sail_green")

func _on_sail_brown_pressed() -> void:
	_on_sail_color_button_pressed("sail_brown")

func _on_sail_beige_pressed() -> void:
	_on_sail_color_button_pressed("sail_fieldlogs")

func _on_sail_pink_pressed() -> void:
	_on_sail_color_button_pressed("sail_pink")

func _on_sail_purple_pressed() -> void:
	_on_sail_color_button_pressed("sail_purple")

func _on_hull_brown_pressed() -> void:
	_on_hull_color_button_pressed("ship_small_hull_brown")

func _on_hull_black_pressed() -> void:
	_on_hull_color_button_pressed("ship_small_hull_black")

func _on_hull_red_pressed() -> void:
	_on_hull_color_button_pressed("ship_small_hull_red")

func _on_hull_green_pressed() -> void:
	_on_hull_color_button_pressed("ship_small_hull_green")

func _on_hull_blue_pressed() -> void:
	_on_hull_color_button_pressed("ship_small_hull_blue")

func _on_hull_pink_pressed() -> void:
	_on_hull_color_button_pressed("ship_small_hull_pink")

func _on_sail_color_button_pressed(sail_color: String) -> void:
	# Sauvegarder le skin dans PlayerSettings
	PlayerSettings.set_sail_skin(sail_color)
	# Appliquer le skin
	apply_sail_skin(sail_color)

func _on_hull_color_button_pressed(hull_color: String) -> void:
	# Sauvegarder le skin dans PlayerSettings
	PlayerSettings.set_hull_skin(hull_color)
	# Appliquer le skin
	apply_hull_skin(hull_color)

func apply_sail_skin(sail_color: String) -> void:
	# Vérifier que le joueur existe
	if not player:
		print("Erreur : Joueur non trouvé")
		return
	
	# Accéder à la MeshInstance3D de la voile (sail-1)
	var sail = player.get_node("ship_small/sail-1")
	if not sail or not sail is MeshInstance3D:
		print("Erreur : Voile non trouvée ou n'est pas une MeshInstance3D")
		return
	
	# Charger le modèle de la voile de la couleur choisie
	var sail_resource = load("res://assets/models/skins/sail/%s.glb" % sail_color)
	if not sail_resource:
		print("Erreur : Impossible de charger %s.glb" % sail_color)
		return
	
	# Instancier la scène pour accéder à son contenu
	var sail_instance = sail_resource.instantiate()
	
	# Trouver la MeshInstance3D dans le modèle chargé
	var sail_mesh = null
	for child in sail_instance.get_children():
		if child is MeshInstance3D:
			sail_mesh = child
			break
	
	if not sail_mesh:
		print("Erreur : Aucun MeshInstance3D trouvé dans %s.glb" % sail_color)
		return
	
	# Appliquer le mesh de la voile à sail-1
	sail.mesh = sail_mesh.mesh
	
	# Nettoyer l'instance pour éviter les fuites de mémoire
	sail_instance.queue_free()
	
	print("Skin de la voile changé en %s" % sail_color)

func apply_hull_skin(hull_color: String) -> void:
	if not player:
		print("Erreur : Joueur non trouvé")
		return
	
	var hull = player.get_node("ship_small")
	if not hull or not hull is MeshInstance3D:
		print("Erreur : Coque non trouvée ou n'est pas une MeshInstance3D")
		return
	
	var hull_resource = load("res://assets/models/skins/hull/%s.glb" % hull_color)
	if not hull_resource:
		print("Erreur : Impossible de charger %s.glb" % hull_color)
		return
	
	var hull_instance = hull_resource.instantiate()
	var hull_mesh = null
	for child in hull_instance.get_children():
		if child is MeshInstance3D:
			hull_mesh = child
			break
	
	if not hull_mesh:
		print("Erreur : Aucun MeshInstance3D trouvé dans %s.glb" % hull_color)
		return
	
	hull.mesh = hull_mesh.mesh
	hull_instance.queue_free()
	
	print("Skin de la coque changé en %s" % hull_color)
