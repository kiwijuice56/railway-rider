class_name Collectable
extends Area

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body: PhysicsBody) -> void:
	pass
