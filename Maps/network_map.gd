extends Node3D

const Connection = preload("res://Maps/connection.tscn")

var connections := {}

func _ready():
	layout_connections()

func get_root_node():
	for node in get_tree().get_nodes_in_group("computer_node"):
		if node.parent_connection_path == NodePath():
			return node
	return null

func layout_connections() -> void:
	for computer_node in get_tree().get_nodes_in_group("computer_node"):
		var parent_node = computer_node.get_parent_connection()
		if parent_node == null:
			continue

		var node_path = str(computer_node.get_path())
		var connection = connections.get(node_path)

		if connection == null:
			connection = Connection.instantiate()
			add_child(connection)
			connections[node_path] = connection

		var connection_vector = parent_node.global_position - computer_node.global_position
		connection.setup_connection(computer_node.global_position + (connection_vector / 2.0), connection_vector)
