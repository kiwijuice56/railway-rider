class_name Player
extends Spatial

export var lane_offset: float = 0.8
export var switch_time: float = 0.12
export var cam_switch_time: float = 0.21

var lane: int = 0

func _process(_delta: float) -> void:
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

func switch_lane(old_lane: int) -> void:
	$AnimationPlayer.play("turn_left" if old_lane > lane else "turn_right")
	
	$Tween.interpolate_property($Train, "translation:x", null, 
	lane_offset * lane, switch_time,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Tween.interpolate_property($Camera, "translation:x", null, 
	lane_offset * lane, cam_switch_time, 
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	$Tween.start()
