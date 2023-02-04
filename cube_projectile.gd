extends Node3D

@onready var cube = $Cube
@onready var inner_cube = $InnerCube

func _physics_process(delta):
	cube.rotate_x(PI * delta)
