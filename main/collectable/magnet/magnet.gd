class_name Magnet
extends Collectable

func _on_body_entered(body: PhysicsBody) -> void:
	GlobalState.score += 150
	body.get_parent().magnet_boost()
	$AnimationPlayer.play("collect")
	yield($AnimationPlayer, "animation_finished")
	call_deferred("queue_free")
