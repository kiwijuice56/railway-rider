class_name TrainObstacle
extends Obstacle

export var base_colors: PoolColorArray = []
export var door_colors: PoolColorArray = []
export var top_colors: PoolColorArray = []

func _ready() -> void:
	var body_mesh: Mesh = $TrainModel/body.mesh.duplicate()
	$TrainModel/body.mesh = body_mesh
	var mat: Material = body_mesh.get("surface_2/material").duplicate()
	mat.albedo_color = base_colors[randi() % len(base_colors)]
	body_mesh.set("surface_2/material", mat)
	
	mat = body_mesh.get("surface_1/material").duplicate()
	mat.albedo_color = door_colors[randi() % len(door_colors)]
	body_mesh.set("surface_1/material", mat)
	
	mat = body_mesh.get("surface_4/material").duplicate()
	mat.albedo_color = top_colors[randi() % len(top_colors)]
	body_mesh.set("surface_4/material", mat)
