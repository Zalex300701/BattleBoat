extends Node3D

@export var ocean_scene: PackedScene
@export var chunk_size: float = 128.0
@export var grid_size: int = 3

var chunks = {}
var last_player_chunk = Vector3.ZERO

func _ready():
	generate_chunks()
	last_player_chunk = get_player_chunk()

func _process(_delta):
	var current_player_chunk = get_player_chunk()

	# Mettre à jour les chunks uniquement si le joueur change de chunk
	if current_player_chunk != last_player_chunk:
		update_chunks(current_player_chunk)
		last_player_chunk = current_player_chunk

func get_player_chunk():
	var player_pos = $"../Player".position
	return Vector3(
		round(player_pos.x / chunk_size) * chunk_size,
		0,
		round(player_pos.z / chunk_size) * chunk_size
	)

func generate_chunks():
	# Générer uniquement les chunks autour du joueur
	var player_chunk = get_player_chunk()
	for x in range(-grid_size, grid_size + 1):
		for z in range(-grid_size, grid_size + 1):
			var pos = player_chunk + Vector3(x * chunk_size, 0, z * chunk_size)
			if pos not in chunks:
				var chunk = ocean_scene.instantiate()
				chunk.position = pos
				add_child(chunk)
				chunks[pos] = chunk

func update_chunks(player_chunk):
	var new_chunks = {}

	# Vérifier quels chunks doivent être conservés
	for pos in chunks.keys():
		if pos.distance_to(player_chunk) <= (grid_size * chunk_size):
			new_chunks[pos] = chunks[pos]  # Conserver les chunks proches
		else:
			chunks[pos].queue_free()  # Supprimer les chunks trop éloignés

	# Mettre à jour la liste des chunks
	chunks = new_chunks

	# Générer les nouveaux chunks autour du joueur
	generate_chunks()
