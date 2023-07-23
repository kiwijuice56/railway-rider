class_name GameUI
extends Control

var can_pause: bool = false
var paused: bool = false

func _ready() -> void:
# warning-ignore:return_value_discarded
	GlobalState.connect("values_changed", self, "_on_values_changed")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause", false) and can_pause:
		if paused:
			unpause()
		else:
			pause()

func pause() -> void:
	$CanvasLayer.visible = true
	paused = true
	get_tree().paused = true

func unpause() -> void:
	$CanvasLayer.visible = false
	paused = false
	get_tree().paused = false

func _on_values_changed() -> void:
	get_node("%ScoreLabel").text = ("%06d" % int(GlobalState.score))
	get_node("%CoinLabel").text = ("%03d" % int(GlobalState.coins))
	get_node("%ScoreMultLabel").text = ("%.2f" % float(GlobalState.score_mult)) + "x"
