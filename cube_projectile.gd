extends Node3D

@onready var cube = $cube
@onready var inner_cube = $inner_cube

func _physics_process(delta):
	cube.rotate_x(PI * delta)
