extends Control

@onready var health_progress: ProgressBar = $"HealthProgress"

func _ready():
	if health_progress == null:
		print("Error: HealthProgress node not found!")
	visible = true

func update_health(new_health: float, max_health: float):
	if health_progress == null:
		print("Error: HealthProgress is null in update_health!")
		return
	health_progress.max_value = max_health
	health_progress.value = new_health
