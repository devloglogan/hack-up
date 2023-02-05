extends AudioStreamPlayer

@export var beeps: Array[AudioStream]

@onready var timer = $Timer

func _on_timer_timeout():
	pitch_scale = randf_range(.8, 1.2)
	stream = beeps.pick_random()
	play()
	
	var time_to_wait = randf_range(.02, 3.0)
	timer.wait_time = time_to_wait
	timer.start()
