class_name TitleScreen
extends Control

func _ready() -> void:
	get_node("../GameUI").modulate.a = 0
	get_node("%PlayButton").connect("button_up", self, "_on_play_pressed")
	get_node("%CreditButton").connect("button_up", self, "_on_credit_pressed")

func _on_play_pressed() -> void:
	get_node("%PlayButton").disabled = true
	get_node("%CreditButton").disabled = true
	
	$Tween.interpolate_property(self, "modulate:a", null, 0.0, 0.3)
	$Tween.interpolate_property(get_node("../GameUI"), "modulate:a", null, 1.0, 0.3)
	$Tween.start()
	yield(get_parent().play(), "completed")
	visible = false

func _on_credit_pressed() -> void:
	get_node("%PlayButton").disabled = true
	get_node("%CreditButton").disabled = true
	
	$Tween.interpolate_property(self, "modulate:a", null, 0.0, 0.3)
	
	$Tween.start()
	yield($Tween, "tween_completed")
	get_node("../CreditScreen").enter()

func enter() -> void:
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.3)
	$Tween.start()
	visible = true
	yield($Tween, "tween_completed")
	
	get_node("%PlayButton").disabled = false
	get_node("%CreditButton").disabled = false
