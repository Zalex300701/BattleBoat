# MusicManager.gd
extends Node

var music_player : AudioStreamPlayer
var normal_volume_db : float = 0.0  # Volume normal
var reduced_volume_db : float = -15.0  # Volume réduit
var fade_duration : float = 0.5  # Durée de la transition en secondes

func _ready():
	# Créer le lecteur audio
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Charger votre fichier musical
	music_player.stream = preload("res://assets/sounds/main_music.ogg")  # Changez le chemin
	music_player.bus = "Music"  # Optionnel : créez un bus audio "Music"
	music_player.volume_db = normal_volume_db
	
	# Activer la lecture en boucle
	if music_player.stream:
		music_player.stream.loop = true

func play_music():
	if not music_player.playing:
		music_player.play()

func stop_music():
	music_player.stop()

func reduce_volume():
	# Transition douce vers le volume réduit
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", reduced_volume_db, fade_duration)

func restore_volume():
	# Transition douce vers le volume normal
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", normal_volume_db, fade_duration)
