class_name Surfer
extends KinematicBody

const GRAVITY: Vector3 = Vector3(0, -32.0, 0)
const JUMP: Vector3 = Vector3(0, 15.0, 0)
const JUMP_BOOST: Vector3 = Vector3(0, 23.0, 0)

export var speed: float = 20
export var lane_offset: float = 0.8
export var switch_time: float = 0.12
export var cam_switch_time: float = 0.21

var lane: int = 0
var velocity: Vector3

func _ready() -> void:
	# initialize animations (cannot be edited in editor)
	$SurferModel.get_child(0).get_node("AnimationPlayer").get_animation("default").loop = true
	$SurferModel.get_child(0).get_node("AnimationPlayer").play("default")


func _physics_process(delta: float) -> void:
	velocity += GRAVITY * delta
	velocity.z = speed
	
	if randi()%60 > 50 and is_on_floor():
		jump()
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	# Implement turning
	if $RayCast.is_colliding():
		pass
	

func jump() -> void:
	velocity += JUMP

func move_right():
	global_translate(Vector3(0,0,lane_offset))

func move_left():
	global_translate(Vector3(0,0,lane_offset * -1))
