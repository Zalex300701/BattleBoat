extends State
class_name EnemyDying

@onready var animation_player = $"../../AnimationPlayer"

func enter() -> void:
	owner.set_physics_process(false)
	animation_player.play("sink")
	await animation_player.animation_finished
	owner.queue_free()

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
