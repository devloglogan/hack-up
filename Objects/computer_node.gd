#@tool
extends StaticBody3D

@export var is_hacked := false
@export var parent_connection_path: NodePath

var security_remaining := 20

signal hacked()
signal hack_failed()

func _physics_process(delta):
	rotate_y(PI * .25 * delta)

func get_parent_connection():
	if parent_connection_path != NodePath():
		var parent_connection = get_node(parent_connection_path)
		if parent_connection != null:
			return parent_connection
	return null

func get_child_connections() -> Array:
	if not is_inside_tree():
		return []

	var children := []
	for computer_node in get_tree().get_nodes_in_group("computer_node"):
		if computer_node.get_parent_connection() == self:
			children.push_back(computer_node)

	return children

func check_hackable() -> bool:
	for computer_node in get_child_connections():
		if not computer_node.is_hacked:
			return false
	return true

func hack(p_remaining):
	if is_hacked or not check_hackable():
		hack_failed.emit()
		return
	if security_remaining != p_remaining:
		security_remaining = p_remaining
		if security_remaining <= 0:
			is_hacked = true
			hacked.emit()
