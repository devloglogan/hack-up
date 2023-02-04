extends Node3D

signal root_node_hacked()

func _ready():
	var root_node = $NetworkMap.get_root_node()
	if root_node:
		root_node.hacked.connect(self._on_root_node_hacked)

func _on_root_node_hacked():
	root_node_hacked.emit()
