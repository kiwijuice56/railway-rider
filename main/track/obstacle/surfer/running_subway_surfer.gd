class_name Surfer
extends Obstacle

export var speed = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	$SurferModel/Running/AnimationPlayer.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_translate(Vector3(0,0,(speed)/float(100)))

