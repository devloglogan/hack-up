extends "res://Menu/window_base.gd"

const SECURITY_MAX := 20
const KeystrokeSound = preload("res://Sound/keystroke/keystroke_sound.tscn")

var _security_remaining := 20
var security_remaining: int:
	set(v):
		_security_remaining = v
		text_node.visible_ratio = float(SECURITY_MAX - _security_remaining) / SECURITY_MAX
	get:
		return _security_remaining

var is_terminal_active := false

signal terminal_completed()
signal security_reduced(remaining)

func _ready():
	clear_terminal()

func clear_terminal():
	security_remaining = SECURITY_MAX

func activate_terminal(p_security_remaining: int = SECURITY_MAX) -> void:
	security_remaining = p_security_remaining
	is_terminal_active = true
	visible = true

func deactivate_terminal() -> void:
	is_terminal_active = false
	visible = false

func _unhandled_key_input(_event):
	if not visible: return

	if security_remaining > 0:
		security_remaining -= 1
		security_reduced.emit(security_remaining)
		var keystroke_sound = KeystrokeSound.instantiate()
		add_child(keystroke_sound)
		if security_remaining == 0:
			deactivate_terminal()
			terminal_completed.emit()
