extends Spatial


export var speed = 20;


# Called when the node enters the scene tree for the first time.
func _ready():
	$SurferModel/AnimationPlayer.play("default")
	


func _physics_process(delta):
	global_translate(Vector3(0,0,(speed)/float(100)))
