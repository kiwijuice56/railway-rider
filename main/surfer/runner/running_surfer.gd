class_name RunningSurfer
extends Surfer

func _physics_process(delta: float) -> void:
	if dead:
		return
	
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
