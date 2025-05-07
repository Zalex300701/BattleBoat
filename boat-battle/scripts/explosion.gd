extends Node3D

@onready var smoke: GPUParticles3D = $Smoke
@onready var debris: GPUParticles3D = $Debris
@onready var fire: GPUParticles3D = $Fire
@onready var cannon_burst: GPUParticles3D = $Cannon_burst
@onready var cannon_damage_smoke: GPUParticles3D = $Cannon_damage_smoke
@onready var cannon_damage_wood: GPUParticles3D = $Cannon_damage_wood

# Bomber explosion
@onready var smoke_bomber: GPUParticles3D = $Bomber_Explosion/Smoke
@onready var debris_bomber: GPUParticles3D = $Bomber_Explosion/Debris
@onready var fire_bomber: GPUParticles3D = $Bomber_Explosion/Fire

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

func damage():
	cannon_damage_smoke.emitting = true
	cannon_damage_wood.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()

func bomber_explosion():
	debris_bomber.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
