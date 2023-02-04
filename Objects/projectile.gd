extends Area3D

const SPEED = 4.0
const LIFETIME = 180

var direction = Vector3()
var countdown := LIFETIME

func _physics_process(delta):
	position += direction * SPEED * delta

	var nodes = get_overlapping_bodies()
	if nodes.size() > 0:
		for node in nodes:
			if node.has_method('hurt'):
				node.hurt(self)
		queue_free()
		return

	countdown -= 1
	if countdown <= 0:
		queue_free()
