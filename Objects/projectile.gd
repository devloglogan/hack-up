extends Area3D

const SPEED = 4.0
const LIFETIME = 180

var direction = Vector3()
var countdown := LIFETIME

func _physics_process(delta):
	position += direction * SPEED * delta

	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.has_method('hurt'):
			body.hurt(self)
		queue_free()
		return

	countdown -= 1
	if countdown <= 0:
		queue_free()
