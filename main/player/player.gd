class_name Player
extends Spatial
# Controls player movement

signal died

const CAMERA_Y: float = 5.1
const CAMERA_SHIFT_THRESHOLD: float = 1.5
const CAMERA_SHIFT: float = 2.0

# Player parameters
export var lane_offset: float = 0.8
export var switch_time: float = 0.12
export var cam_switch_time: float = 0.21

var lane: int = 0
var dead: bool = false
var vel: Dictionary = {}
var first_land: bool = false

func _ready() -> void:
	get_node("%Magnet").scale = Vector3(0,0,0)
	get_node("%Frog").scale = Vector3(0,0,0)
	
# warning-ignore:return_value_discarded
	$Train.connect("landed", self, "_on_train_landed")
# warning-ignore:return_value_discarded
	$JumpBoostTimer.connect("timeout", self, "_on_jump_boost_timeout")
# warning-ignore:return_value_discarded
	$MagnetBoostTimer.connect("timeout", self, "_on_magnet_boost_timeout")
# warning-ignore:return_value_discarded
	$Train/AttractArea.connect("area_entered", self, "_on_coin_entered")

func _process(delta: float) -> void:
	# On death, shoot out train parts
	if dead:
		for mesh in $Train/TrainModel.get_children():
			if not mesh is MeshInstance:
				continue
			mesh.translation += vel[mesh] * delta * 32
		return
	
	# Sync camera's y position
	if Input.is_action_pressed("jump"):
		$Camera/Tween.interpolate_property($Camera, "original_translation:y", null, 
		CAMERA_Y + CAMERA_SHIFT * (2 if $Train.boosted else 1), cam_switch_time, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Camera/Tween.interpolate_property($Camera, "translation:y", null, 
		CAMERA_Y + CAMERA_SHIFT * (2 if $Train.boosted else 1), cam_switch_time, 
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
	if first_land:
		first_land = false
		return
	
	$CrashPlayer.pitch_scale = rand_range(0.8, 1.1)
	$CrashPlayer.play()
	$Camera.shake(0.25, 40, 0.2)

func _on_jump_boost_timeout() -> void:
	$Train/FrogAnimationPlayer.play("frog_out")
	$Train.boosted = false

func _on_magnet_boost_timeout() -> void:
	$Train/MagnetAnimationPlayer.play("magnet_out")
	$Train/AttractArea/CollisionShape.disabled = true

func _on_coin_entered(area: Area) -> void:
	if not area is Coin or area.magnetized:
		return
	area.magnetized = true
	call_deferred("magnet_collect", area)

func magnet_collect(coin: Coin) -> void:
	var global_pos: Vector3 = coin.global_translation
	coin.get_parent().remove_child(coin)
	get_tree().get_root().get_node("Main").add_child(coin)
	coin.global_translation = global_pos
	coin.target = $Train
	coin.set_physics_process(true)

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
	$MagnetBoostTimer.stop()
	$JumpBoostTimer.stop()
	
	set_process(false)
	
	dead = false
	first_land = true
	$Train.translation.y = 1.3
	$Train/CollisionShape.call_deferred("set", "disabled", false)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")
	yield($AnimationPlayer, "animation_finished")
	
	# Reset powerups
	$Train/MagnetAnimationPlayer.stop()
	$Train/FrogAnimationPlayer.stop()
	
	get_node("%Magnet").scale = Vector3(0,0,0)
	get_node("%Frog").scale = Vector3(0,0,0)
	
	$Train/AttractArea/CollisionShape.disabled = true
	$Train.boosted = false
	
	set_process(true)

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
	$Train/FrogAnimationPlayer.play("frog_in")
	
	$JumpBoostTimer.start()
	$Train.boosted = true

func magnet_boost() -> void:
	$Train/MagnetAnimationPlayer.play("magnet_in")
	
	$MagnetBoostTimer.start()
	$Train/AttractArea/CollisionShape.disabled = false

func kill() -> void:
	$ExplosionStreamPlayer.playing = true
	$Camera.shake(0.65, 60, 0.3)
