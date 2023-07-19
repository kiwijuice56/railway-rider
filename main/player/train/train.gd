class_name Train
extends KinematicBody

const GRAVITY: Vector3 = Vector3(0, -24.0, 0)
const JUMP: Vector3 = Vector3(0, 12.0, 0)

var velocity: Vector3

func _physics_process(delta: float) -> void:
	velocity += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	velocity.z = 0
	translation.z = 0

func jump() -> void:
	velocity.y = 0
	velocity += JUMP