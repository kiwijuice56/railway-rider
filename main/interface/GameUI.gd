extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("menu"):
		pause()


func pause():
	get_tree().paused = true
	pause_mode = PAUSE_MODE_PROCESS
	$PauseMenu.show()
	

func _on_ResumeButton_pressed():
	get_tree().paused = false
	$PauseMenu.hide()


func _on_MenuButton_pressed():
	pass # Replace with function body.
