extends Control

@onready var health_progress: ProgressBar = $"HealthProgress"
@onready var player: CharacterBody3D = $"../Player"

func _ready():
	print(player.current_health, ' / ' , player.current_health)
	if health_progress == null:
		print("Error: HealthProgress node not found!")
	visible = true

func update_health(new_health: float, max_health: float):
	if health_progress == null:
		print("Error: HealthProgress is null in update_health!")
		return
	health_progress.max_value = max_health
	health_progress.value = new_health


func _on_player_health_changed(new_health: Variant, max_health: Variant) -> void:
	pass # Replace with function body.
