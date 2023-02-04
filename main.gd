extends Node

@onready var terminal_window = %TerminalWindow
@onready var level = $Level

var node_being_hacked

func _ready():
	load_level("res://Maps/Level1/level_1.tscn")

func load_level(path):
	var packed_scene = load(path)
	if packed_scene == null or not packed_scene is PackedScene:
		return

	if level != null:
		remove_child(level)
		level.queue_free()

	level = packed_scene.instantiate()
	level.name = "Level"
	add_child(level)

	level.root_node_hacked.connect(self._on_root_node_hacked)

func _on_player_hack_activated(node):
	if not node_being_hacked and not node.is_hacked and node.check_hackable():
		node_being_hacked = node
		terminal_window.activate_terminal(node_being_hacked.security_remaining)

func _on_player_player_moved():
	if node_being_hacked:
		terminal_window.deactivate_terminal()
		node_being_hacked = null

func _on_terminal_window_security_reduced(remaining):
	if node_being_hacked:
		node_being_hacked.hack(remaining)

func _on_terminal_window_terminal_completed():
	node_being_hacked = null

func _on_root_node_hacked():
	OS.alert("You hacked the root node!")
