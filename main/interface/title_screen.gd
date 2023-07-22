class_name TitleScreen
extends Control

func _ready() -> void:
	get_node("%PlayButton").connect("button_up", self, "_on_play_pressed")

func _on_play_pressed() -> void:
	get_node("%PlayButton").disabled = true
	get_node("%CreditButton").disabled = true
	
	$Tween.interpolate_property(self, "modulate:a", null, 0.0, 0.3)
	$Tween.start()
	yield(get_parent().play(), "completed")
	visible = false
