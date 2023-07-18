class_name Main
extends Node

const TRACK_LENGTH: int = 24
const TRACK_PATH: String = "res://main/tracks/"

export var speed: float = 10
export var render_distance: int = 10

var tracks: Array

func _ready() -> void:
	randomize()
	# Load all tracks
	# https://docs.godotengine.org/en/3.6/classes/class_directory.html
	var dir = Directory.new()
	if dir.open(TRACK_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				tracks.append(load(TRACK_PATH + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	# Initiate starting tracks
	for i in range(1-render_distance,1):
		# Choose random track out of all track options
		var track: Spatial = tracks[randi() % tracks.size()].instance()
		# Move track to correct position
		$Tracks.add_child(track)
		track.global_translate(Vector3(0, 0, TRACK_LENGTH*i))

func _physics_process(_delta: float) -> void:
	for track in $Tracks.get_children():
		# Move tracks to create effect of train moving
		track.global_translate(Vector3(0, 0, speed/100.0))
		
		# Cull tracks that have left the screen
		if track.to_global(Vector3(0,0,0)).z > 20:
			$Tracks.remove_child(track)
			track.queue_free()
			
			# Add new track at farthest render distance to replace culled track
			var new_track: Spatial = tracks[randi() % tracks.size()].instance()
			$Tracks.add_child(new_track)
			new_track.global_translate(Vector3(0, 0, TRACK_LENGTH*(1-render_distance)))
