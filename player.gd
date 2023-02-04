extends CharacterBody3D

const SPEED := 5.0
const HURT_SPEED := 10.0
const HURT_FRAMES := 10

var is_hurt := false
var hurt_vector := Vector3.ZERO
var hurt_count := 0

func _physics_process(_delta):
	if is_hurt:
		velocity = hurt_vector * HURT_SPEED
		if hurt_count > 0:
			hurt_count -= 1
		if hurt_count <= 0:
			is_hurt = false
	else:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func hurt(attacker, push_back_vector: Vector3 = Vector3.ZERO):
	is_hurt = true
	if push_back_vector != Vector3.ZERO:
		hurt_vector = push_back_vector.normalized()
	else:
		hurt_vector = (global_position - attacker.global_position).normalized()
	hurt_vector.y = 0.0
	hurt_count = HURT_FRAMES
