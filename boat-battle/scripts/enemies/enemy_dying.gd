extends State
class_name EnemyDying

@onready var animation_player = $"../../AnimationPlayer"
@onready var sfx_sink: AudioStreamPlayer3D = $"../../sfx_sink"

var sink_animations := ["sink_1", "sink_2", "sink_3", "sink_4"]

func enter() -> void:
	owner.set_physics_process(false)
	var chosen_animation = sink_animations[randi() % sink_animations.size()]
	sfx_sink.play()
	animation_player.play(chosen_animation)
	await animation_player.animation_finished
	owner.queue_free()

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
