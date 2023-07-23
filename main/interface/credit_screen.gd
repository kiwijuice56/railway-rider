class_name CreditScreen
extends Control

func _ready() -> void:
	modulate.a = 0
	get_node("../UIBlocker").modulate.a = 0
	
	get_node("%BackButton").disabled = true
	visible = false
	
# warning-ignore:return_value_discarded
	get_node("%BackButton").connect("button_up", self, "_on_back_pressed")

func _on_back_pressed() -> void:
	get_node("%BackButton").disabled = true
	
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.3)
	$Tween.interpolate_property(get_node("../UIBlocker"), "modulate:a", 1.0, 0.0, 0.3)
	$Tween.start()
	visible = true
	yield($Tween, "tween_completed")
	get_node("../TitleScreen").enter()
	visible = false

func enter() -> void:
	$Tween.interpolate_property(get_node("../UIBlocker"), "modulate:a", 0.0, 1.0, 0.3)
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.3)
	$Tween.start()
	visible = true
	yield($Tween, "tween_completed")
	
	get_node("%BackButton").disabled = false
	get_node("%BackButton").grab_focus()
