class_name Main
extends Node


export var speed = 10
export var render_distance = 10

onready var tracks = [preload("res://main/Basic Tracks.tscn")]

var TRACK_LENGTH = 24


func _ready():
	randomize()
	# Initiate starting tracks
	for i in range(1-render_distance,1):
		# Choose random track out of all track options
		var track = tracks[randi() % tracks.size()].instance()
		# Move track to correct position
		track.global_translate(Vector3(0, 0, TRACK_LENGTH*i))

		$Tracks.add_child(track)
		


func _physics_process(delta):
	for track in $Tracks.get_children():
		# Move tracks to create effect of train moving
		track.global_translate(Vector3(0, 0, speed/float(100)))
		
		# Cull tracks that have left the screen
		if track.to_global(Vector3(0,0,0)).z > 20:
			track.queue_free()
			
			# Add new track at farthest render distance to replace culled track
			var new_track = tracks[randi() % tracks.size()].instance()
			new_track.global_translate(Vector3(0, 0, TRACK_LENGTH*(1-render_distance)))
			$Tracks.add_child(new_track)
