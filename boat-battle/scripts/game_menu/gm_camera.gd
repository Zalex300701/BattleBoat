extends Camera3D

@onready var player: CharacterBody3D = get_node("/root/GameMenu/Environment/Player") 
@onready var menu_marker: Marker3D = get_node("/root/GameMenu/Markers/Menu_marker")
@onready var boathouse_marker: Marker3D = get_node("/root/GameMenu/Markers/Boathouse_marker")

var target_position: Vector3
var is_transitioning: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !player.is_leaving:
		look_at(player.global_transform.origin + Vector3(0, 3, 0))
	
	if is_transitioning:
		position = position.lerp(target_position, delta * 2)  # 2 = vitesse, ajuste comme tu veux
		if position.distance_to(target_position) < 0.05:
			position = target_position
			is_transitioning = false

func boathouse_position():
	target_position = boathouse_marker.position
	is_transitioning = true

func menu_position():
	target_position = menu_marker.position
	is_transitioning = true
