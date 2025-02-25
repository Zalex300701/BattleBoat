extends Camera3D

var height_above_player = 45.0
var distance_from_player = 30.0
@onready var player: Node3D = get_node("/root/Game/Player") 

func _ready() -> void:
	# Initial position of the camera
	position = Vector3(0, height_above_player, 0)
	
	# Initial rotation of the camera
	rotation_degrees = Vector3(-45, 0, 0)

func _process(delta: float) -> void:
	update_camera_position()

func update_camera_position():
	position = player.global_transform.origin + Vector3(0, height_above_player, distance_from_player)
	
