extends Spatial


export var obstacle_frequency = 100
export var simulation_distance = 100



var obstacles = [preload("res://main/obstacles/Subway Surfer.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if randf() < obstacle_frequency/float(3000):
		var x = randi()%3
		var y = randi()%2

		
		var obstacle = obstacles[randi() % obstacles.size()].instance()
		obstacle.global_translate(Vector3(-3+3*x, y*2.5, -simulation_distance))

		obstacle.speed = 10 + randf() * 20
		add_child(obstacle)


	for child in get_children():
		if child.to_global(Vector3(0,0,0)).z >= 24:
			child.queue_free()
	
		
