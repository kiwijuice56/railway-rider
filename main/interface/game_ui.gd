class_name GameUI
extends Control


func _ready() -> void:
	GlobalState.connect("values_changed", self, "_on_values_changed")

func _on_PauseButton_pressed():
	get_tree().paused = true
	pause_mode = PAUSE_MODE_PROCESS
	$PauseButton.hide()
	$PauseMenu.show()
	

func _on_ResumeButton_pressed():
	$PauseButton.show()
	$PauseMenu.hide()
	get_tree().paused = false


func _on_MenuButton_pressed():
	pass # Replace with function body.

func _on_values_changed() -> void:
	get_node("%ScoreLabel").text = ("%07d" % int(GlobalState.score))
	get_node("%CoinLabel").text = ("%03d" % int(GlobalState.coins))
	get_node("%ScoreMultLabel").text = ("%.2f" % float(GlobalState.score_mult)) + "x"
