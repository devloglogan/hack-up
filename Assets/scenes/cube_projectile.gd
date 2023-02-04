extends Node3D

@export var rotation_rate = .75

@onready var cube = $Cube
@onready var inner_cube = $InnerCube

func _physics_process(delta):
	cube.rotate_x(PI * rotation_rate * delta)
	cube.rotate_y(PI * rotation_rate * delta)
	inner_cube.rotate_x(-PI * rotation_rate * delta)
	inner_cube.rotate_z(-PI * rotation_rate * delta)
