extends Node
# Stores global variables 
# Not good practice, but works for a smaller game like this

var gravity_direction: Vector2 = Vector2.DOWN
var score: float = 0 setget set_score
var high_score: float = 0
var coins: int = 0 setget set_coins
var score_mult: float = 1.0 setget set_score_mult

signal values_changed

func set_score(val: float) -> void:
	high_score = max(high_score, score)
	score = val
	emit_signal("values_changed")

func set_coins(val: int) -> void:
	coins = val
	emit_signal("values_changed")

func set_score_mult(val: float) -> void:
	score_mult = val
	emit_signal("values_changed")
