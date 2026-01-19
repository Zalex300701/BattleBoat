extends CanvasLayer

@export var zoom: float = 0.5

@onready var minimap_camera = $MinimapContainer/ViewportContainer/MinimapViewport/MinimapCamera
@onready var player = get_node("../Player")
@onready var main_camera = get_node("../Camera3D")
@onready var minimap_container = $MinimapContainer
@onready var player_icon = player.get_node("PlayerIcon")

var enemy_icons = []
@onready var minimap_center = Vector2(90, 90)
var minimap_radius = 130.0
var world_to_map_scale = 0.5

func _ready():
	minimap_camera.global_transform.origin = player.global_transform.origin + Vector3(0, 20, 0)
	minimap_camera.size = 100 / zoom

func _process(_delta):
	# Mise à jour caméra minimap
	minimap_camera.global_transform.origin = player.global_transform.origin + Vector3(0, 20, 0)
	if player_icon:
		player_icon.global_position = player.global_position + Vector3(0, 1, 0)
		var player_yaw = player.global_transform.basis.get_euler().y
		player_icon.global_rotation = Vector3(deg_to_rad(-90), player_yaw, 0)
	var camera_yaw = main_camera.global_transform.basis.get_euler().y
	minimap_container.rotation = camera_yaw
	
	update_enemy_icons()

func update_enemy_icons():
	# Récupère les ennemis
	var enemies = get_tree().get_nodes_in_group("Enemies")
	
	# Crée/supprime icônes dynamiquement si besoin
	while enemy_icons.size() > enemies.size():
		var extra_icon = enemy_icons.pop_back()
		extra_icon.queue_free()
	while enemy_icons.size() < enemies.size():
		var new_icon = preload("res://scenes/ui/enemy_icon.tscn").instantiate()
		new_icon.visible = true
		$MinimapIcons.add_child(new_icon)
		enemy_icons.append(new_icon)
	
	const MINIMAP_RADIUS_WORLD = 85.0
	const ICON_HEIGHT = 1.5
	
	# Update chaque icône avec clamping
	for i in range(enemies.size()):
		var enemy = enemies[i]
		var icon = enemy_icons[i]
		
		if not is_instance_valid(enemy):
			icon.visible = false
			continue
		
		var rel_pos = enemy.global_transform.origin - player.global_transform.origin
		rel_pos.y = 0
		
		var distance = rel_pos.length()
		
		if distance > MINIMAP_RADIUS_WORLD:
			rel_pos = rel_pos.normalized() * MINIMAP_RADIUS_WORLD
		
		icon.global_transform.origin = player.global_transform.origin + rel_pos + Vector3(0, ICON_HEIGHT, 0)
		icon.visible = true
