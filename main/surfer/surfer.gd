class_name Surfer
extends KinematicBody

const GRAVITY: Vector3 = Vector3(0, -32.0, 0)
const JUMP: Vector3 = Vector3(0, 15.0, 0)

export var speed: float = 4
export var lane_offset: float = 3.0
export var switch_time: float = 0.3
export var cam_switch_time: float = 0.21

var lane: int = 0
var velocity: Vector3

func _ready() -> void:
	lane = randi() % 2 - 1
	translation.x = lane_offset * lane
	# Initialize animations (cannot be edited in the editor for import reasons...)
	var anim: AnimationPlayer = $SurferModel.get_child(0).get_node("AnimationPlayer")
	anim.get_animation("default").loop = true
	anim.play("default")

func _physics_process(delta: float) -> void:
	velocity += GRAVITY * delta
	velocity.x = 0
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if randf() < 0.002 and not $Left.is_colliding() and not $Tween.is_active() and lane > -1:
		var old_lane: int = lane
		lane -= 1
		#switch_lane(old_lane)
	if randf() < 0.002 and not $Right.is_colliding() and not $Tween.is_active() and lane < 1:
		var old_lane: int = lane
		lane += 1
		#switch_lane(old_lane)
	
	if is_on_floor():
		velocity.z = speed 
	else:
		velocity.z = speed * 3
	
	# TODO: Implement turning
	if $Front.is_colliding() and is_on_floor():
		jump()
	

func jump() -> void:
	velocity += JUMP

func death() -> void:
	call_deferred("queue_free")

# warning-ignore:unused_argument
func switch_lane(old_lane: int) -> void:
	#var dir: String = "left" if old_lane > lane else "right"
	#$AnimationPlayer.play("turn_" + dir + "_surfer")
	
	$Tween.interpolate_property(self, "translation:x", null, 
	lane_offset * lane, switch_time,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Tween.start()
