class_name Coin
extends Collectable

export var speed: float = 0.5
var target: Spatial
var magnetized: bool = false

func _ready() -> void:
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	global_translation += (target.global_translation - global_translation).normalized() * speed

func _on_body_entered(_body: PhysicsBody) -> void:
	set_physics_process(false)
	GlobalState.coins += 1
	GlobalState.score += 5
	
	_on_audio_changed()
	$AnimationPlayer.play("collect")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
