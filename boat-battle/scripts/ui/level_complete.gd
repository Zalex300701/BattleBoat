extends Control

# Signals for button presses
signal next_level_pressed
signal menu_pressed

@onready var title_label = $Panel/VBoxContainer/Title_text
@onready var stats_label = $Panel/VBoxContainer/Stats_text
@onready var next_level_button = $Panel/VBoxContainer/NextLevel_button
@onready var menu_button = $Panel/VBoxContainer/Menu_button

func _ready():
	# Set up UI
	title_label.text = "Level Completed!"
	stats_label.text = "Time: "
	next_level_button.pressed.connect(_on_next_level_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)

func _on_next_level_button_pressed():
	emit_signal("next_level_pressed")
	queue_free() # Remove the UI

func _on_menu_button_pressed():
	emit_signal("menu_pressed")
	print("yes2")
	queue_free() # Remove the UI
