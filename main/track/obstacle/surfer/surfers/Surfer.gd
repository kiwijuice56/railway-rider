extends Spatial


const GRAVITY: Vector3 = Vector3(0, -32.0, 0)
const JUMP: Vector3 = Vector3(0, 15.0, 0)
const JUMP_BOOST: Vector3 = Vector3(0, 23.0, 0)

export var speed = 20;
export var lane_offset: float = 0.8
export var switch_time: float = 0.12
export var cam_switch_time: float = 0.21

var lane: int = 0
var velocity: Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	$SurferModel.get_node("AnimationPlayer").play("default")

	

	


func _physics_process(delta):
	velocity += GRAVITY * delta
	if randi()%60 > 50:
		jump()

	
	global_translate(Vector3(0,0,(speed)/float(100)))
	if $RayCast.is_colliding():
		pass
		
	

func jump() -> void:
	velocity.y = 0
	velocity += JUMP


func move_right():

	global_translate(Vector3(0,0,lane_offset))


func move_left():
	global_translate(Vector3(0,0,lane_offset * -1))
