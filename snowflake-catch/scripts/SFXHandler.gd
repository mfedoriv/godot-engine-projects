extends Node
class_name SFXPlayerClass
 
 
func play_sfx(sound: AudioStream, volume_db: float = 1.0, pitch_range: Vector2 = Vector2(1.0, 1.0), 
			parent: Node = get_tree().current_scene):
	if sound != null and parent != null:
		var stream_player = AudioStreamPlayer.new()

		stream_player.stream = sound
		stream_player.connect("finished", stream_player.queue_free)
		stream_player.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
		stream_player.volume_db = volume_db
		stream_player.bus = "SFX"
#		stream_player.pause_mode = pause_behavior

		parent.add_child(stream_player)
		stream_player.play()


func play_random_sfx(sounds: Array, volume_db: float = 1.0,
			pitch_range: Vector2 = Vector2(0.9, 1.1),
			parent: Node = get_tree().current_scene):
	if sounds != null and parent != null:
		var sound_number = randi() % len(sounds)
		play_sfx(sounds[sound_number], volume_db, pitch_range, parent)

