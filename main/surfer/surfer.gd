class_name Surfer
extends KinematicBody

const GRAVITY: Vector3 = Vector3(0, -32.0, 0)
const JUMP: Vector3 = Vector3(0, 16.0, 0)

export var speed: float = 2
export var lane_offset: float = 3.0
export var switch_time: float = 0.3

var lane: int = 0
var velocity: Vector3
var dead: bool = false

func _ready() -> void:
	lane = randi() % 2 - 1
	translation.x = lane_offset * lane
	# Initialize animations (cannot be edited in the editor for import reasons...)
	var anim: AnimationPlayer = $SurferModel.get_child(0).get_node("AnimationPlayer")
	anim.get_animation("default").loop = true
	anim.play("default")
	
	$HitArea.connect("body_entered", self, "_on_player_hit")

func _physics_process(delta: float) -> void:
	if dead:
		velocity.y -= delta * 32 
		translation += velocity * delta
		rotation_degrees.x += 256 * delta
		rotation_degrees.z += 64 * delta
		return
	
	
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

func _on_player_hit(body: PhysicsBody) -> void:
	body.get_parent().kill()
	death()

func jump() -> void:
	$SwooshPlayer.play()
	velocity += JUMP

func death() -> void:
	dead = true
	velocity = Vector3(2.0 * (randf() - 0.5), randf() / 2.0, -randf() - 0.5).normalized() * 64
	$Timer.start()
	yield($Timer, "timeout")
	call_deferred("queue_free")

func switch_lane() -> void:
	$SwooshPlayer.play()
	
	$Tween.interpolate_property(self, "translation:x", null, 
	lane_offset * lane, switch_time,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Tween.start()
