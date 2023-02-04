extends StaticBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func setup_connection(pos: Vector3, vector: Vector3):
	global_position = pos
	global_transform.basis = Basis.looking_at(vector)
	mesh_instance.mesh.size.z = vector.length()
