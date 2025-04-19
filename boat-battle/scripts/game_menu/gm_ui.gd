extends Node

@onready var player = $"../Environment/Player"
@onready var camera = $"../Camera3D"

func _ready() -> void:
	# Charger le skin sauvegardé au démarrage (optionnel, si tu utilises un fichier)
	#PlayerSettings.load_from_file()
	# Appliquer le skin sauvegardé au joueur actuel
	apply_sail_skin(PlayerSettings.get_sail_skin())

func _on_start_pressed():
	if player and player.has_method("leave_and_start"):
		$Main_menu.hide()
		player.leave_and_start("res://scenes/levels/game.tscn")

func _on_boathouse_button_pressed() -> void:
	if camera and camera.has_method("boathouse_position"):
		camera.boathouse_position()
		$Main_menu.hide()
		$Boathouse_menu.show()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_back_boathouse_pressed() -> void:
	if camera and camera.has_method("main_position"):
		camera.main_position()
		$Main_menu.show()
		$Boathouse_menu.hide()

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
	_on_sail_color_button_pressed("sail_beige")

func _on_sail_pink_pressed() -> void:
	_on_sail_color_button_pressed("sail_pink")

func _on_sail_purple_pressed() -> void:
	_on_sail_color_button_pressed("sail_purple")

func _on_sail_color_button_pressed(sail_color: String) -> void:
	# Sauvegarder le skin dans PlayerSettings
	PlayerSettings.set_sail_skin(sail_color)
	# Appliquer le skin
	apply_sail_skin(sail_color)

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
