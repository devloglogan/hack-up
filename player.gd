extends CharacterBody3D

const SPEED := 5.0
const HURT_SPEED := 10.0
const HURT_FRAMES := 10
const MAX_HEALTH := 3

@onready var hack_area: Area3D = $HackArea
@onready var player_visual = $PlayerVisual
@onready var damage_sound = $DamageSound

var is_hurt := false
var hurt_vector := Vector3.ZERO
var hurt_count := 0

var health := MAX_HEALTH
var is_dead := false
var is_playing := false

signal hack_activated(node)
signal player_moved()
signal player_hurt()
signal player_died()

func reset_player():
	health = MAX_HEALTH
	is_dead = false
	$AnimationPlayer.play("RESET")

func _physics_process(_delta):
	if not is_playing:
		return
	if is_hurt:
		velocity = hurt_vector * HURT_SPEED
		if hurt_count > 0:
			hurt_count -= 1
		if hurt_count <= 0:
			is_hurt = false
			if is_dead:
				player_died.emit()
	else:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity = velocity.lerp(direction * SPEED, .1)
		else:
			velocity = velocity.lerp(Vector3.ZERO, .1)

	player_visual.rotation.z = velocity.x * -.05
	player_visual.rotation.x = deg_to_rad(-21) + velocity.z * .05
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not is_playing or is_hurt:
		return
	if event.is_action_pressed("player_activate_terminal"):
		get_viewport().set_input_as_handled()

		var nodes = hack_area.get_overlapping_bodies()
		for node in nodes:
			if node.has_method('hack'):
				hack_activated.emit(node)

	if event.is_action_pressed("player_forward") or event.is_action_pressed("player_back") or event.is_action_pressed("player_left") or event.is_action_pressed("player_right"):
		player_moved.emit()

func hurt(attacker, push_back_vector: Vector3 = Vector3.ZERO):
	if is_hurt:
		return

	if health <= 0:
		return
	health -= 1
	damage_sound.play()
	if health == 0:
		is_dead = true

	is_hurt = true
	if push_back_vector != Vector3.ZERO:
		hurt_vector = push_back_vector.normalized()
	else:
		hurt_vector = (global_position - attacker.global_position).normalized()
	hurt_vector.y = 0.0
	hurt_count = HURT_FRAMES
	player_hurt.emit()
	$AnimationPlayer.play("Hurt")


func hack_failed():
	$AnimationPlayer.play("HackFailed")
