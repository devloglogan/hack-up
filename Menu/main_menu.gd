extends "res://Menu/window_base.gd"

const MyMenuButton = preload("menu_button.tscn")

@onready var button_container = $ButtonContainer

signal level_selected (path)

func show_menu():
	visible = true
	$AnimationPlayer.play("Start")

func hide_menu():
	visible = false

func setup_level_menu(levels: Array):
	for child in button_container.get_children():
		button_container.remove_child(child)

	var level_number := 0
	for level_path in levels:
		var level_button = MyMenuButton.instantiate()
		button_container.add_child(level_button)
		level_button.text = "> Vector %s" % level_number
		level_button.pressed.connect(self._on_level_button_pressed.bind(level_path))
		level_number += 1

func _on_level_button_pressed(level_path):
	level_selected.emit(level_path)

func _focus_first_button():
	if button_container.get_child_count() > 0:
		button_container.get_child(0).grab_focus()
