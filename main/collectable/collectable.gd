class_name Collectable
extends Area

export var volume: float

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")
	GlobalState.connect("audio_changed", self, "_on_audio_changed")

func _on_audio_changed() -> void:
# warning-ignore:incompatible_ternary
	$CollectPlayer.volume_db = -80 if GlobalState.sfx_mute else volume

func _on_body_entered(_body: PhysicsBody) -> void:
	_on_audio_changed()
	$AnimationPlayer.play("collect")
