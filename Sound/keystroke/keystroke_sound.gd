extends AudioStreamPlayer

@export var keystroke_sounds: Array[AudioStream]

func _ready():
	stream = keystroke_sounds.pick_random()
	pitch_scale = randf_range(.9, 1.1)
	play()

func _on_finished():
	queue_free()
