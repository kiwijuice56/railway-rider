class_name SurferSpawner
extends Spatial

export var seconds_per_spawn: float = 3

var runners = [
	preload("res://main/surfer/runner/jake/Jake.tscn")
]
var flyers = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if randf() < 1/float(60*seconds_per_spawn):
		var surfer = runners[randi() % runners.size()].instance()
		var farthest_track: Spatial = get_node("../Tracks").get_child(get_node("../Tracks").get_child_count() - 1)
		farthest_track.add_child(surfer)
