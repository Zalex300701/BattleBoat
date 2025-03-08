extends Node3D

@onready var smoke: GPUParticles3D = $Smoke
@onready var debris: GPUParticles3D = $Debris
@onready var fire: GPUParticles3D = $Fire
@onready var cannon_burst: GPUParticles3D = $Cannon_burst


func die_explosion():
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()

func cannon_explosion():
	cannon_burst.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
