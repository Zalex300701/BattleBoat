extends CanvasLayer

@export var zoom: float = 0.5

@onready var minimap_camera = $MinimapContainer/ViewportContainer/MinimapViewport/MinimapCamera
@onready var player = get_node("../Player")
@onready var main_camera = get_node("../Camera3D")
@onready var minimap_container = $MinimapContainer
@onready var player_icon = player.get_node("PlayerIcon")

func _ready():
	minimap_camera.global_transform.origin = player.global_transform.origin + Vector3(0, 20, 0)
	minimap_camera.size = 100 / zoom

func _process(delta):
	minimap_camera.global_transform.origin = player.global_transform.origin + Vector3(0, 20, 0)
	if player_icon:
		player_icon.global_position = player.global_position + Vector3(0, 1, 0)
		# Get the player's yaw
		var player_yaw = player.global_transform.basis.get_euler().y
		# Set the PlayerIcon's rotation: X = -90 degrees to face the camera, Y = player's yaw, Z = 0
		player_icon.global_rotation = Vector3(deg_to_rad(-90), player_yaw, 0)
	var camera_yaw = main_camera.global_transform.basis.get_euler().y
	minimap_container.rotation = camera_yaw
