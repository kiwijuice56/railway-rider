extends Spatial


export var seconds_per_spawn = 3
export var spawn_distance = 100

var runners = []
var flyers = []

# Called when the node enters the scene tree for the first time.
func _ready():

	load_scenes("res://main/track/obstacle/surfer/surfers/runners/", runners)
	load_scenes("res://main/track/obstacle/surfer/surfers/flyers/", flyers)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if randf() < 1/float(60*seconds_per_spawn):
		print(runners)
		var x = randi()%3
		var y = randi()%2
		
		
		var surfer = runners[randi() % runners.size()].instance()
		surfer.speed = 10 + randi()%10 + get_parent().speed

		add_child(surfer)

		
		surfer.global_translate(Vector3(-3+3*x, y*2.5, -spawn_distance))
		


	for child in get_children():
		if child.to_global(Vector3(0,0,0)).z >= 24:
			child.queue_free()



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
