extends Node

@onready var terminal_window = %TerminalWindow

var node_being_hacked

func _ready():
	#var node = $Level/NetworkMap/BranchA
	#print (node.get_child_connections())
	pass

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
