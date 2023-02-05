extends "res://Objects/computer_node.gd"

@export var barrier_sounds: Array[AudioStream]

@onready var zap_mesh_instance = $ZapMeshInstance
@onready var zap_particles = $ZapParticles
@onready var zap_barrier_sound = $ZapBarrierSound

var is_zapping := false

func _ready():
	hacked.connect(self._on_hacked)

func _physics_process(_delta):
	if is_zapping:
		var bodies = $ZapArea.get_overlapping_bodies()
		for body in bodies:
			if body.has_method('hurt'):
				body.hurt(self)

func _on_zap_timer_timeout():
	if is_hacked:
		return
	is_zapping = not is_zapping
	zap_mesh_instance.visible = is_zapping
	zap_particles.visible = is_zapping
	
	if is_zapping:
		zap_barrier_sound.stream = barrier_sounds.pick_random()
		zap_barrier_sound.play()

func _on_hacked():
	is_zapping = false
	zap_mesh_instance.visible = is_zapping
	zap_particles.visible = is_zapping

