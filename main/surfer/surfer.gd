class_name Surfer
extends KinematicBody

const GRAVITY: Vector3 = Vector3(0, -32.0, 0)
const JUMP: Vector3 = Vector3(0, 16.0, 0)

export var speed: float = 4
export var lane_offset: float = 3.0
export var switch_time: float = 0.3

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
	if is_on_wall():
		death()
	
	velocity += GRAVITY * delta
	velocity.x = 0
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if is_on_floor():
		velocity.z = speed 
	else:
		velocity.z = speed * 3
	
	if $Front.is_colliding():
		var old_lane: int = lane
		if lane == 0:
			if not $FrontLeft.is_colliding():
				lane += 1
			elif not $FrontRight.is_colliding():
				lane -= 1
			elif is_on_floor():
				jump()
		elif lane == -1:
			if not $FrontLeft.is_colliding():
				lane += 1
			elif is_on_floor():
				jump()
			else:
				lane += 1
		else:
			if not $FrontRight.is_colliding():
				lane -= 1
			elif is_on_floor():
				jump()
			else:
				lane -= 1
		
		if old_lane != lane and not $Tween.is_active() and is_on_floor():
			switch_lane()
		else:
			lane = old_lane
	

func jump() -> void:
	velocity += JUMP

func death() -> void:
	call_deferred("queue_free")

func switch_lane() -> void:
	#var dir: String = "left" if old_lane > lane else "right"
	#$AnimationPlayer.play("turn_" + dir + "_surfer")
	
	$Tween.interpolate_property(self, "translation:x", null, 
	lane_offset * lane, switch_time,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Tween.start()
