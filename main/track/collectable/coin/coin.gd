class_name Coin
extends Collectable

func _on_body_entered(_body: PhysicsBody) -> void:
	GlobalState.coins += 1
	GlobalState.score += 5
	
	$AnimationPlayer.play("collect")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
