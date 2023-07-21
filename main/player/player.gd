class_name Player
extends Spatial
# Controls player movement

signal died

const CAMERA_Y: float = 4.9
const CAMERA_SHIFT_THRESHOLD: float = 1.6
const CAMERA_SHIFT: float = 2.0

# Player parameters
export var lane_offset: float = 0.8
export var switch_time: float = 0.12
export var cam_switch_time: float = 0.21

var lane: int = 0
var dead: bool = false
var vel: Dictionary = {}

func _ready() -> void:
# warning-ignore:return_value_discarded
	$Train.connect("landed", self, "_on_train_landed")
# warning-ignore:return_value_discarded
	$JumpBoostTimer.connect("timeout", self, "_on_jump_boost_timeout")

func _process(delta: float) -> void:
	# On death, shoot out train parts
	if dead:
		for mesh in $Train/TrainModel.get_children():
			if not mesh is MeshInstance:
				continue
			mesh.translation += vel[mesh] * delta * 32
		return
	
	# Sync camera's y position
	if $Train.translation.y > CAMERA_SHIFT_THRESHOLD and $Camera.translation.y <= CAMERA_Y:
		$Camera/Tween.interpolate_property($Camera, "original_translation:y", null, 
		CAMERA_Y + CAMERA_SHIFT, cam_switch_time, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Camera/Tween.interpolate_property($Camera, "translation:y", null, 
		CAMERA_Y + CAMERA_SHIFT, cam_switch_time, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Camera/Tween.start()
	if $Train.translation.y < CAMERA_SHIFT_THRESHOLD and $Camera.translation.y >= CAMERA_Y:
		$Camera/Tween.interpolate_property($Camera, "original_translation:y", null, 
		CAMERA_Y, cam_switch_time, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Camera/Tween.interpolate_property($Camera, "translation:y", null, 
		CAMERA_Y, cam_switch_time, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Camera/Tween.start()
	
	if not $Tween.is_active() and Input.is_action_pressed("jump") and $Train.is_on_floor():
		$Train.jump()
		$AnimationPlayer.stop()
		$AnimationPlayer.play("jump")
	
	var old_lane: int = lane
	if Input.is_action_pressed("move_left"):
		lane -= 1
	elif Input.is_action_pressed("move_right"):
		lane += 1
	lane = int(clamp(lane, -1, 1))
	
	if old_lane != lane and not $Tween.is_active():
		switch_lane(old_lane)
	else:
		lane = old_lane

func _on_train_landed() -> void:
	$CrashPlayer.pitch_scale = rand_range(0.8, 1.1)
	$CrashPlayer.play()
	$Camera.shake(0.25, 40, 0.2)

func _on_jump_boost_timeout() -> void:
	$Train.boosted = false

func switch_lane(old_lane: int) -> void:
	# Add some variation to most common sound
	$SwooshPlayer.pitch_scale = rand_range(0.7, 1.2)
	
	# Animate the train
	$AnimationPlayer.stop()
	var dir: String = "left" if old_lane > lane else "right"
	if $Train.is_on_floor():
		$AnimationPlayer.play("turn_" + dir)
	else:
		$AnimationPlayer.play("flip_" + dir)
	
	# Tween camera and train at an offset
	
	$Tween.interpolate_property($Train, "translation:x", null, 
	lane_offset * lane, switch_time,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	# Both properties need to be set on the ScreenShakeCamera
	
	$Tween.interpolate_property($Camera, "original_translation:x", null, 
	lane_offset * lane, cam_switch_time, 
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Tween.interpolate_property($Camera, "translation:x", null, 
	lane_offset * lane, cam_switch_time, 
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Tween.start()

func reset() -> void:
	dead = false
	$Train.translation.y = 1.216
	$AnimationPlayer.play("RESET")
	$Train/CollisionShape.call_deferred("set", "disabled", false)
	_on_jump_boost_timeout()

func death() -> void:
	$ExplosionStreamPlayer.playing = true
	$Camera.shake(0.65, 60, 0.3)
	
	for mesh in $Train/TrainModel.get_children():
		if not mesh is MeshInstance:
			continue
		vel[mesh] = Vector3(2 * randf() - 1.0, randf() + 0.2, 2 * randf() - 1.0).normalized()
	
	dead = true
	
	$Train/CollisionShape.call_deferred("set", "disabled", true)
	$Timer.start()
	yield($Timer, "timeout")
	
	emit_signal("died")

func jump_boost() -> void:
	$JumpBoostTimer.start()
	$Train.boosted = true
