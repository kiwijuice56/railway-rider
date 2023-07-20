class_name Surfer
extends Obstacle

export var speed = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	$SurferModel/Running/AnimationPlayer.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_translate(Vector3(0,0,speed/float(100)))
	$SurferModel/Running/AnimationPlayer.playback_speed = speed/20
