extends Node3D

@onready var smoke: GPUParticles3D = $Smoke
@onready var debris: GPUParticles3D = $Debris
@onready var fire: GPUParticles3D = $Fire
@onready var shockwave: GPUParticles3D = $Shockwave
@onready var cannon_burst: GPUParticles3D = $Cannon_burst
@onready var cannon_damage_smoke: GPUParticles3D = $Cannon_damage_smoke
@onready var cannon_damage_wood: GPUParticles3D = $Cannon_damage_wood
@onready var spark: GPUParticles3D = $Spark

@onready var sfx_wood_break: AudioStreamPlayer3D = $sfx_wood_break
@onready var sfx_explosion: AudioStreamPlayer3D = $sfx_explosion
@onready var sfx_fuse: AudioStreamPlayer3D = $sfx_fuse

func cannon_explosion():
	cannon_burst.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()

func damage():
	cannon_damage_smoke.emitting = true
	cannon_damage_wood.emitting = true
	sfx_wood_break.play()
	await get_tree().create_timer(2.0).timeout
	queue_free()

func bomber_spark():
	spark.emitting = true
	sfx_fuse.play()
	await get_tree().create_timer(3.5).timeout
	queue_free()

func die_explosion():
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true
	shockwave.emitting = true
	sfx_explosion.play()
	await get_tree().create_timer(2.0).timeout
	queue_free()
