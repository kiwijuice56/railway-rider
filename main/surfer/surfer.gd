class_name Surfer
extends KinematicBody

const GRAVITY: Vector3 = Vector3(0, -32.0, 0)
const JUMP: Vector3 = Vector3(0, 15.0, 0)
const JUMP_BOOST: Vector3 = Vector3(0, 23.0, 0)

export var speed: float = 6
export var lane_offset: float = 3.0
export var switch_time: float = 0.12
export var cam_switch_time: float = 0.21

var lane: int = 0
var velocity: Vector3

func _ready() -> void:
	translation.x += lane_offset
	# Initialize animations (cannot be edited in the editor for import reasons...)
	var anim: AnimationPlayer = $SurferModel.get_child(0).get_node("AnimationPlayer")
	anim.get_animation("default").loop = true
	anim.play("default")

func _physics_process(delta: float) -> void:
	velocity += GRAVITY * delta
	velocity.z = speed
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	# TODO: Implement turning
	if $RayCast.is_colliding() and is_on_floor():
		jump()
	

func jump() -> void:
	velocity += JUMP

func move_right() -> void:
	global_translate(Vector3(0,0,lane_offset))

func move_left() -> void:
	global_translate(Vector3(0,0,lane_offset * -1))
