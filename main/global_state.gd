extends Node
# Stores global variables 
# Not good practice, but works for a smaller game like this

var gravity_direction: Vector2 = Vector2.DOWN
var score: float = 0 setget set_score
var high_score: float = 0
var coins: int = 0 setget set_coins
var total_coins: int = 0
var score_mult: float = 1.0 setget set_score_mult
var music_mute: bool = false setget set_music
var sfx_mute: bool = false setget set_sfx

signal values_changed
signal audio_changed

func _ready() -> void:
	if ResourceLoader.exists("user://save.tres"):
		var save: SaveFile = ResourceLoader.load("user://save.tres")
		total_coins = save.data.total_coins
		high_score = save.data.high_score
		
		sfx_mute = save.data.sfx_mute
		music_mute = save.data.music_mute

func save() -> void:
	var save_file: SaveFile = SaveFile.new()
	save_file.data = {"total_coins": total_coins, "high_score": high_score, "sfx_mute": sfx_mute, "music_mute": music_mute}
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

func set_music(val: bool) -> void:
	music_mute = val
	emit_signal("audio_changed")
	save()

func set_sfx(val: bool) -> void:
	sfx_mute = val
	emit_signal("audio_changed")
	save()
