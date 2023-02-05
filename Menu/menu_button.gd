extends Button

@onready var keystroke_sound = $KeystrokeSound

func play_keystroke():
	keystroke_sound.pitch_scale = randf_range(.9, 1.1)
	keystroke_sound.play()

func _on_focus_entered():
	play_keystroke()

func _on_pressed():
	play_keystroke()
