class_name Surfer
extends KinematicBody

const GRAVITY: Vector3 = Vector3(0, -32.0, 0)
const JUMP: Vector3 = Vector3(0, 15.0, 0)
const JUMP_BOOST: Vector3 = Vector3(0, 23.0, 0)

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
	velocity.z = speed
	velocity.x = 0
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if randf() < 0.01 and not $Left.is_colliding() and not $Tween.is_active() and lane > -1:
		var old_lane: int = lane
		lane -= 1
		switch_lane(old_lane)
	if randf() < 0.01 and not $Right.is_colliding() and not $Tween.is_active() and lane < 1:
		var old_lane: int = lane
		lane += 1
		switch_lane(old_lane)
	
	# TODO: Implement turning
	if $Front.is_colliding() and is_on_floor():
		jump()
	

func jump() -> void:
	velocity += JUMP

func switch_lane(old_lane: int) -> void:
#	var dir: String = "left" if old_lane > lane else "right"
#	if $Train.is_on_floor():
#		$AnimationPlayer.play("turn_" + dir)
#	else:
#		$AnimationPlayer.play("flip_" + dir)
	
	
	$Tween.interpolate_property(self, "translation:x", null, 
	lane_offset * lane, switch_time,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Tween.start()
