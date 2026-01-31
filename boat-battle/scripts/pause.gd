extends Control

@onready var pause = $"."
var paused = false
var game_menu_scene: String = "res://scenes/levels/game_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var current_scene = get_tree().current_scene
		if current_scene.scene_file_path != game_menu_scene:
			pause_menu()

func _on_resume_button_pressed() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused = false
		paused = !paused

func _on_exit_button_pressed() -> void:
	SceneTransition.change_scene(game_menu_scene)
	
	# Restore music volume
	MusicManager.restore_volume()

func pause_menu():
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.show()
	paused = !paused
