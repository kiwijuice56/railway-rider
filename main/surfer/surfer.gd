class_name Surfer
extends KinematicBody

const GRAVITY: Vector3 = Vector3(0, -32.0, 0)
const JUMP: Vector3 = Vector3(0, 16.0, 0)

export var score_mult: float = 0.25
export var speed: float = 2
export var lane_offset: float = 3.0
export var switch_time: float = 0.3

var lane: int = 0
var velocity: Vector3
var dead: bool = false
var just_jumped: bool = false

func _ready() -> void:
	lane = randi() % 2 - 1
	translation.x = lane_offset * lane
	# Initialize animations (cannot be edited in the editor for import reasons...)
	var anim: AnimationPlayer = $SurferModel.get_child(0).get_node("AnimationPlayer")
	
	anim.get_animation("default").loop = true
	anim.play("default")
	
# warning-ignore:return_value_discarded
	$HitArea.connect("body_entered", self, "_on_player_hit")

func _physics_process(delta: float) -> void:
	if dead:
		velocity.y -= delta * 32 
		translation += velocity * delta
		rotation_degrees.x += 256 * delta
		rotation_degrees.z += 64 * delta
		rotation_degrees.z += 64 * delta
		return
	var anim: AnimationPlayer = $SurferModel.get_child(0).get_node("AnimationPlayer")
	if is_on_wall():
		death()
	if is_on_floor():
		if not just_jumped:
			anim.play()
		else:
			just_jumped = false

func _on_player_hit(body: PhysicsBody) -> void:
	body.get_parent().kill()
	$YellPlayer.pitch_scale = rand_range(0.7, 1.3)
	$YellPlayer.play()
	$ImpactPlayer.pitch_scale = rand_range(0.7, 1.3)
	$ImpactPlayer.play()
	death()

func jump() -> void:
	just_jumped = true
	var anim: AnimationPlayer = $SurferModel.get_child(0).get_node("AnimationPlayer")
	
	$SwooshPlayer.play()
	if $SurferModel.get_child(0).has_node("Jump"):
		anim.stop(false)
		$SurferModel.get_child(0).get_node("Jump").play("default")
	velocity += JUMP

func switch_lane() -> void:
	$SwooshPlayer.play()
	
	$Tween.interpolate_property(self, "translation:x", null, 
	lane_offset * lane, switch_time,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Tween.start()

func death() -> void:
	GlobalState.score_mult += score_mult
	
	dead = true
	velocity = Vector3(2.0 * (randf() - 0.5), 0.6, -randf() - 0.8).normalized() * 64
	$Timer.start()
	yield($Timer, "timeout")
	call_deferred("queue_free")
