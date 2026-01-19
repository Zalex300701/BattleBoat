extends Control

# Signals for button presses
signal next_level_pressed
signal menu_pressed

@onready var title_label = $Panel/Title_text
@onready var stats_label = $Panel/VBoxContainer/Stats_text
@onready var next_level_button = $Panel/VBoxContainer/NextLevel_button
@onready var menu_button = $Panel/VBoxContainer/Menu_button
@onready var sfx_level_finished: AudioStreamPlayer = $sfx_level_finished

func _ready():
	title_label.text = "[rainbow freq=0.12 sat=0.75 val=1][center][wave amp=20 freq=8]Level Completed![/wave][/center][/rainbow]"
	stats_label.text = "Time: 00:00:00"
	next_level_button.pressed.connect(_on_next_level_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)
	next_level_button.grab_focus()
	sfx_level_finished.play()

func set_level_time(time_seconds: float):
	var minutes = int(time_seconds / 60)
	var seconds = int(time_seconds) % 60
	var centiseconds = int((time_seconds - int(time_seconds)) * 100)
	stats_label.text = "Time: %02d:%02d:%02d" % [minutes, seconds, centiseconds]

func _on_next_level_button_pressed():
	emit_signal("next_level_pressed")
	queue_free() # Remove the UI

func _on_menu_button_pressed():
	emit_signal("menu_pressed")
	queue_free() # Remove the UI
