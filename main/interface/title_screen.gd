class_name TitleScreen
extends Control

func _ready() -> void:
	get_node("../GameUI").modulate.a = 0
# warning-ignore:return_value_discarded
	get_node("%PlayButton").connect("button_up", self, "_on_play_pressed")
# warning-ignore:return_value_discarded
	get_node("%HelpButton").connect("button_up", self, "_on_help_pressed")
# warning-ignore:return_value_discarded
	get_node("%CreditButton").connect("button_up", self, "_on_credit_pressed")
	
	yield(get_tree().get_root(), "ready")
	enter()

func _on_play_pressed() -> void:
	get_node("%PlayButton").disabled = true
	get_node("%HelpButton").disabled = true
	get_node("%CreditButton").disabled = true
	
	$Tween.interpolate_property(self, "modulate:a", null, 0.0, 0.3)
	$Tween.interpolate_property(get_node("../GameUI"), "modulate:a", null, 1.0, 0.3)
	$Tween.start()
	yield(get_parent().play(), "completed")
	visible = false

func _on_help_pressed() -> void:
	get_node("%PlayButton").disabled = true
	get_node("%HelpButton").disabled = true
	get_node("%CreditButton").disabled = true
	
	$Tween.interpolate_property(self, "modulate:a", null, 0.0, 0.3)
	
	$Tween.start()
	yield($Tween, "tween_completed")
	
	get_node("../HelpScreen").enter()

func _on_credit_pressed() -> void:
	get_node("%PlayButton").disabled = true
	get_node("%HelpButton").disabled = true
	get_node("%CreditButton").disabled = true
	
	$Tween.interpolate_property(self, "modulate:a", null, 0.0, 0.3)
	
	$Tween.start()
	yield($Tween, "tween_completed")
	get_node("../CreditScreen").enter()

func enter() -> void:
	$HighScoreLabel.text = "Your high score: %07d\nTotal coins: %03d" % [int(GlobalState.high_score), int(GlobalState.total_coins)]
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.3)
	$Tween.interpolate_property(get_node("../GameUI"), "modulate:a", null, 0.0, 0.3)
	$Tween.start()
	visible = true
	yield($Tween, "tween_completed")
	
	get_node("%PlayButton").disabled = false
	get_node("%HelpButton").disabled = false
	get_node("%CreditButton").disabled = false
	
	get_node("%PlayButton").grab_focus()
