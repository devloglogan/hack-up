extends "res://Menu/window_base.gd"

const MyMenuButton = preload("menu_button.tscn")

var key_sounds: Array[AudioStream]

@onready var button_container = $ButtonContainer
@onready var text_sound = $TextSound
@onready var keystroke_sound = $KeystrokeSound

signal ok_pressed ()
signal cancel_pressed ()

func _ready():
	key_sounds.append(preload("res://Sound/text/v2/GGJ_text_01_v2.wav"))
	key_sounds.append(preload("res://Sound/text/v2/GGJ_text_04_v2.wav"))
	key_sounds.append(preload("res://Sound/text/v2/GGJ_text_05_v2.wav"))
	key_sounds.append(preload("res://Sound/text/v2/GGJ_text_06_v2.wav"))

func show_accept_menu(message, ok_text, cancel_text):
	for child in button_container.get_children():
		button_container.remove_child(child)

	$Text.text = message

	if ok_text != "":
		var ok_button = _add_button(ok_text)
		ok_button.pressed.connect(self._on_ok_pressed)

	if cancel_text != "":
		var cancel_button = _add_button(cancel_text)
		cancel_button.pressed.connect(self._on_cancel_pressed)

	visible = true
	$AnimationPlayer.play("Start")

func _add_button(text):
	var button = MyMenuButton.instantiate()
	button_container.add_child(button)
	button.text = "> " + text
	return button

func _focus_first_button():
	if button_container.get_child_count() > 0:
		button_container.get_child(0).grab_focus()

func _on_ok_pressed():
	visible = false
	ok_pressed.emit()

func _on_cancel_pressed():
	visible = false
	cancel_pressed.emit()

func _physics_process(delta):
	if $AnimationPlayer.current_animation == "Start" and not text_sound.playing:
		text_sound.stream = key_sounds.pick_random()
		text_sound.play()
