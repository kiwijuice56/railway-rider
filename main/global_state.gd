extends Node
# Stores global variables 
# Not good practice, but works for a smaller game like this

var gravity_direction: Vector2 = Vector2.DOWN
var score: float = 0 setget set_score
var high_score: float = 0
var coins: int = 0 setget set_coins
var total_coins: int = 0
var score_mult: float = 1.0 setget set_score_mult

signal values_changed

func _ready() -> void:
	if ResourceLoader.exists("user://save.tres"):
		var save: SaveFile = ResourceLoader.load("user://save.tres")
		total_coins = save.data.total_coins
		high_score = save.data.high_score

func save() -> void:
	var save_file: SaveFile = SaveFile.new()
	save_file.data = {"total_coins": total_coins, "high_score": high_score}
# warning-ignore:return_value_discarded
	ResourceSaver.save("user://save.tres", save_file)

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
