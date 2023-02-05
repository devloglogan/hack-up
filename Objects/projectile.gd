extends Area3D

const SPEED = 4.0
const LIFETIME = 180

var direction = Vector3()
var countdown := LIFETIME

@onready var projectile_sound = $ProjectileSound

func _ready():
	projectile_sound.doppler_tracking = AudioStreamPlayer3D.DOPPLER_TRACKING_PHYSICS_STEP
	projectile_sound.attenuation_filter_db = -12

func _physics_process(delta):
	position += direction * SPEED * delta

	var nodes = get_overlapping_bodies()
	if nodes.size() > 0:
		for node in nodes:
			if node.has_method('hurt'):
				node.hurt(self, direction)
		queue_free()
		return

	countdown -= 1
	if countdown <= 0:
		queue_free()
