class_name Main
extends Node
# Root node, controls track scrolling and spawning

const TRACK_LENGTH: int = 24
const TRACK_MAIN_PATH: String = "res://main/track/main/"
const TRACK_BG_PATH: String = "res://main/track/background/"
const INITIAL_PATH: String = "res://main/track/main/Basic.tscn"

# Game parameters
export var initial_speed: float = 6
export var max_speed: float = 64
export var score_per_speed: float = 0.003
export var accel: float = 0.001
export var render_distance: int = 10

var speed: float
var main_tracks: Array
var bg_tracks: Array

var paused: bool = true

func _ready() -> void:
	randomize()
	get_tree().paused = true
	
	# Load all tracks
	# https://docs.godotengine.org/en/3.6/classes/class_directory.html
	load_scenes(TRACK_MAIN_PATH, main_tracks)
	load_scenes(TRACK_BG_PATH, bg_tracks)
	
	reset()
	

func _physics_process(_delta: float) -> void:
	if paused:
		return
	
	# Increment score and speed
	GlobalState.score += speed * score_per_speed * GlobalState.score_mult
	speed += accel
	speed = min(speed, max_speed)
	
	for child in $Tracks.get_children() + $Backgrounds.get_children():
		# Move tracks to create effect of train moving
		child.global_translate(Vector3(0, 0, speed / 100.0))
		
		# Cull tracks that have left the screen
		if child.to_global(Vector3()).z >= TRACK_LENGTH:
			var offset: float = child.to_global(Vector3()).z - TRACK_LENGTH
			
			var parent: Spatial = child.get_parent()
			parent.remove_child(child)
			child.queue_free()
			
			# Add new track at farthest render distance to replace culled track
			var new_child: Spatial
			
			if parent == $Tracks:
				new_child = main_tracks[randi() % main_tracks.size()].instance()
			else:
				new_child = bg_tracks[randi() % bg_tracks.size()].instance()
			
			# Flipping gives more variation 
			if randf() < 0.5:
				new_child.scale.x = -1
			
			# Adding a child will overlap it with the player unless it is spawned far away
			new_child.translation.y = -100
			parent.add_child(new_child)
			new_child.translation = Vector3(0, 0, offset + TRACK_LENGTH * (1 - render_distance))

func load_scenes(path: String, array: Array) -> void:
	var dir: Directory = Directory.new()
# warning-ignore:return_value_discarded
	dir.open(path)
# warning-ignore:return_value_discarded
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			array.append(load(path + file_name))
		file_name = dir.get_next()

func play() -> void:
	$Tween.interpolate_property($TitleCamera, "transform", null, $Player/Camera.transform, 1.0 if $TitleCamera.current else 0.2,
	Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	$TitleCamera.current = false
	$Player/Camera.current = true
	
	get_tree().paused = false
	$SurferSpawner/Timer.start()
	$Skyline.modulate=Color(1, 1, 1, 0)
	$Tween.interpolate_property($Skyline, "modulate", 
	  Color(1, 1, 1, 0), Color(1, 1, 1, .3), 3.0, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	

# Reset game to initial state
func reset() -> void:
	$Skyline.modulate=Color(1, 1, 1, 0)
	$SurferSpawner/Timer.stop()
	paused = false
	GlobalState.score = 0
	GlobalState.score_mult = 1.0
	GlobalState.coins = 0
	
	for child in $Tracks.get_children() + $Backgrounds.get_children():
		child.get_parent().remove_child(child)
		child.queue_free()
	
	# Initiate starting tracks
	for i in range(1 - render_distance, 1):
		# Choose random track out of all track options
		var track: Spatial = main_tracks[randi() % main_tracks.size()].instance()
		
		# Ensure starting path is empty
		if i >= -1:
			track = preload(INITIAL_PATH).instance()
		
		var bg: Spatial = bg_tracks[randi() % bg_tracks.size()].instance()
		
		# Move track to correct position
		$Tracks.add_child(track)
		$Backgrounds.add_child(bg)
		track.global_translate(Vector3(0, 0, TRACK_LENGTH * i))
		bg.global_translate(Vector3(0, 0, TRACK_LENGTH * i))
		if randf() < 0.5:
			bg.scale.x = -1
		if randf() < 0.5:
			track.scale.x = -1
	
	yield($Player.reset(), "completed")
	
	speed = initial_speed
	

func death() -> void:
	GlobalState.total_coins += GlobalState.coins
	GlobalState.save()
	
	paused = true
	$Player.death()
	yield($Player, "died")
	$Tween.interpolate_property($Player/Camera, "fov", 70, 1, 0.8)
	$Tween.start()
	yield($Tween, "tween_completed")
	yield(reset(), "completed")
	$Tween.interpolate_property($Player/Camera, "fov", 1, 70, 0.8)
	get_tree().paused = true
	$TitleScreen.enter()
