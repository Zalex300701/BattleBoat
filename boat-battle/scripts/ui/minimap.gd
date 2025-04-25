extends CanvasLayer

@export var zoom: float = 0.5

@onready var minimap_camera = $MinimapContainer/ViewportContainer/MinimapViewport/MinimapCamera
@onready var player = get_node("../Player")
@onready var main_camera = get_node("../Camera3D")
@onready var minimap_container = $MinimapContainer
@onready var player_icon = player.get_node("PlayerIcon") # Changed to reference PlayerIcon under Player

func _ready():
	print("Minimap _ready called")
	print("Player: ", player)
	print("PlayerIcon: ", player_icon)
	print("Player children: ", player.get_children())
	minimap_camera.global_transform.origin = player.global_transform.origin + Vector3(0, 20, 0)
	minimap_camera.size = 100 / zoom
	print("MinimapCamera Cull Mask: ", minimap_camera.cull_mask)
	var enemies = get_tree().get_nodes_in_group("Enemies")
	print("Enemies found: ", enemies.size())
	for enemy in enemies:
		var enemy_icon = enemy.get_node("EnemyIcon")
		if enemy_icon:
			print("Enemy position: ", enemy.global_position)
			print("EnemyIcon Layers: ", enemy_icon.layers)
			print("EnemyIcon Visible: ", enemy_icon.visible)
		else:
			print("EnemyIcon not found for enemy: ", enemy)

func _process(delta):
	minimap_camera.global_transform.origin = player.global_transform.origin + Vector3(0, 20, 0)
	# Ensure the PlayerIcon follows the player but ignores rotation
	if player_icon:
		player_icon.global_position = player.global_position + Vector3(0, 1, 0)
		player_icon.global_rotation = Vector3.ZERO
	var camera_yaw = main_camera.global_transform.basis.get_euler().y
	minimap_container.rotation = -camera_yaw
