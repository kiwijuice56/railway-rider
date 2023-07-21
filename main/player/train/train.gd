class_name Train
extends KinematicBody

const GRAVITY: Vector3 = Vector3(0, -32.0, 0)
const JUMP: Vector3 = Vector3(0, 15.0, 0)

signal landed

var velocity: Vector3

func _physics_process(delta: float) -> void:
	velocity += GRAVITY * delta
	var was_on_floor: bool = is_on_floor()
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if not was_on_floor and is_on_floor():
		emit_signal("landed")
	
	velocity.z = 0
	translation.z = 0

func jump() -> void:
	velocity.y = 0
	velocity += JUMP
