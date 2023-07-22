extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Score count needs to be discussed, counter depends on score modifiers
	# For every coin gained increment counter by one (do not keep right justified)
	pass


func _on_PauseButton_pressed():
	# Pause entire game except for pause menu
	get_tree().paused = true
	$".".pause_mode = PAUSE_MODE_PROCESS
	$PauseButton.hide()
	$PauseContainer.show()


func _on_ResumeButton_pressed():
	$PauseContainer.hide()
	$PauseButton.show()
	get_tree().paused = false


func _on_MenuButton_pressed():
	get_tree().paused = false
