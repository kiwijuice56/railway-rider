class_name Main
extends Node

const TRACK_LENGTH: int = 24
const TRACK_MAIN_PATH: String = "res://main/track/main/"
const TRACK_BG_PATH: String = "res://main/track/background/"

export var speed: float = 10
export var render_distance: int = 10

var main_tracks: Array
var bg_tracks: Array

func _ready() -> void:
	randomize()
	# Load all tracks
	# https://docs.godotengine.org/en/3.6/classes/class_directory.html
	var dir = Directory.new()
	if dir.open(TRACK_MAIN_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				main_tracks.append(load(TRACK_MAIN_PATH + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	dir = Directory.new()
	if dir.open(TRACK_BG_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				bg_tracks.append(load(TRACK_BG_PATH + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	# Initiate starting tracks
	for i in range(1-render_distance,1):
		# Choose random track out of all track options
		var track: Spatial = main_tracks[randi() % main_tracks.size()].instance()
		var bg: Spatial = bg_tracks[randi() % bg_tracks.size()].instance()
		
		# Move track to correct position
		$Tracks.add_child(track)
		$Backgrounds.add_child(bg)
		track.global_translate(Vector3(0, 0, TRACK_LENGTH*i))
		bg.global_translate(Vector3(0, 0, TRACK_LENGTH*i))

func _physics_process(_delta: float) -> void:
	for child in $Tracks.get_children() + $Backgrounds.get_children():
		# Move tracks to create effect of train moving
		child.global_translate(Vector3(0, 0, speed/100.0))
		
		# Cull tracks that have left the screen
		if child.to_global(Vector3(0,0,0)).z >= 24:
			var parent: Spatial = child.get_parent()
			parent.remove_child(child)
			child.queue_free()
			
			# Add new track at farthest render distance to replace culled track
			var new_child: Spatial
			
			if parent == $Tracks:
				new_child = main_tracks[randi() % main_tracks.size()].instance()
			else:
				new_child = bg_tracks[randi() % bg_tracks.size()].instance()
			
			parent.add_child(new_child)
			new_child.global_translate(Vector3(0, 0, TRACK_LENGTH*(1-render_distance)))
