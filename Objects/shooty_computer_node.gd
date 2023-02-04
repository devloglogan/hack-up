extends "res://Objects/computer_node.gd"

const Projectile = preload("res://Objects/projectile.tscn")

var SHOOT_DIRECTIONS := [
	# The cardinal directions.
	[
		Vector3(-1, 0,  0),
		Vector3( 1, 0,  0),
		Vector3( 0, 0, -1),
		Vector3( 0, 0,  1),
	],
	# The diagonals.
	[
		Vector3(-1, 0, -1).normalized(),
		Vector3(-1, 0,  1).normalized(),
		Vector3( 1, 0, -1).normalized(),
		Vector3( 1, 0,  1).normalized(),
	]
]

enum ShootDirection {
	CARDINAL = 0,
	DIAGONAL,
	ALTERNATING,
}
@export var shoot_direction := ShootDirection.CARDINAL

var _cur_shoot_direction := ShootDirection.CARDINAL

func _ready():
	shoot_projectiles.call_deferred()

func shoot_projectiles() -> void:
	if shoot_direction == ShootDirection.ALTERNATING:
		_cur_shoot_direction = ShootDirection.DIAGONAL if _cur_shoot_direction == ShootDirection.CARDINAL else ShootDirection.CARDINAL
	else:
		_cur_shoot_direction = shoot_direction

	for direction in SHOOT_DIRECTIONS[_cur_shoot_direction]:
		shoot_projectile(direction)

func shoot_projectile(direction: Vector3):
	var parent = get_parent()
	if parent != null:
		var projectile = Projectile.instantiate()
		projectile.direction = direction
		parent.add_child(projectile)
		projectile.global_position = global_position

func _on_shoot_timer_timeout():
	shoot_projectiles()
