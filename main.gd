extends Node

const LEVELS := [
	"res://Maps/Level1/level_1.tscn",
]

@onready var player = $Player
@onready var player_start_position: Vector3 = player.global_position
@onready var terminal_window = %TerminalWindow
@onready var level = $Level
@onready var camera_3d = %Camera3D
@onready var interpolated_camera_3d = %InterpolatedCamera3D

var node_being_hacked
var current_level_path

func _ready():
	await get_tree().create_timer(0.3).timeout

	%MainMenu.setup_level_menu(LEVELS)
	show_main_menu()

func show_main_menu():
	player.is_playing = false
	%MainMenu.show_menu()

func _on_main_menu_level_selected(path):
	%MainMenu.hide_menu()
	load_level(path)

func load_level(path):
	var packed_scene = load(path)
	if packed_scene == null or not packed_scene is PackedScene:
		return

	current_level_path = path

	if level != null:
		remove_child(level)
		level.queue_free()

	level = packed_scene.instantiate()
	level.name = "Level"
	add_child(level)

	level.root_node_hacked.connect(self._on_root_node_hacked)

	player.reset_player()
	player.global_position = player_start_position
	player.is_playing = true
	%HealthLabel.text = str(player.health)
	snap_camera()

func unload_level():
	if level:
		remove_child(level)
		level.queue_free()
		level = null

	player.reset_player()
	player.global_position = player_start_position
	%HealthLabel.text = str(player.health)

func snap_camera():
	camera_3d.make_current()
	await get_tree().process_frame
	interpolated_camera_3d.global_position = camera_3d.global_position
	interpolated_camera_3d.make_current()

func _on_player_hack_activated(node):
	if not node_being_hacked:
		if not node.is_hacked and node.check_hackable():
			node_being_hacked = node
			terminal_window.activate_terminal(node_being_hacked.security_remaining)
		else:
			$Player.hack_failed()

func _on_player_player_moved():
	if node_being_hacked:
		terminal_window.deactivate_terminal()
		node_being_hacked = null

func _on_player_player_hurt():
	%HealthLabel.text = str(player.health)
	if node_being_hacked:
		terminal_window.deactivate_terminal()
		node_being_hacked = null

func _on_terminal_window_security_reduced(remaining):
	if node_being_hacked:
		node_being_hacked.hack(remaining)

func _on_terminal_window_terminal_completed():
	node_being_hacked = null

func _on_root_node_hacked():
	player.is_playing = false
	%AcceptMenu.show_accept_menu("You hacked the root node!", "Advance to next vector", "Return to main menu")

func _on_player_player_died():
	player.is_playing = false
	%AcceptMenu.show_accept_menu("Your feeble system intrusion was stopped by the networks defenses.", "Retry current attack vector", "Return to main menu")

func _on_accept_menu_ok_pressed():
	if player.is_dead:
		load_level(current_level_path)
	else:
		# Figure out the next level
		var index = LEVELS.find(current_level_path)
		index += 1
		if index >= LEVELS.size():
			index = 0
		load_level(LEVELS[index])

func _on_accept_menu_cancel_pressed():
	unload_level()
	show_main_menu()
