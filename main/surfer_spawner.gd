class_name SurferSpawner
extends Spatial

export var seconds_per_spawn: float = 6.0
export var seconds_per_spawn_range: float = 5.0

onready var tracks: Spatial = get_node("../Tracks")

var runners = [
	preload("res://main/surfer/runner/jake/Jake.tscn"),
	preload("res://main/surfer/runner/blake/Blake.tscn"),
	#preload("res://main/surfer/runner/minion/Minion.tscn")
]
var flyers = []

func _ready() -> void:
# warning-ignore:return_value_discarded
	$Timer.connect("timeout", self, "spawn_surfer")
	$Timer.start(seconds_per_spawn + seconds_per_spawn_range * (randf() - 0.5))

func spawn_surfer() -> void:
	var surfer = runners[randi() % runners.size()].instance()
	var farthest_track: Spatial = tracks.get_child(tracks.get_child_count() - 1)
	farthest_track.add_child(surfer)
	surfer.translation.y = 3
	$Timer.start(seconds_per_spawn + seconds_per_spawn_range * (randf() - 0.5))
