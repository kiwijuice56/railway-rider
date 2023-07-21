class_name Obstacle
extends Spatial
# Root class for all objects that kill the player

func _ready() -> void:
# warning-ignore:return_value_discarded
	$KillArea.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body: PhysicsBody) -> void:
	get_tree().get_root().get_node("Main").death()
