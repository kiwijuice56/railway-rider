class_name ScreenShakeCamera
extends Camera
# https://gist.github.com/vctr-uniq/f919478b694f1d1d461f29a3eab24838

var duration: float = 0.0
var period_in_ms: float = 0.0
var amplitude: float = 0.0
var timer: float = 0.0
var last_shook_timer: float = 0
var prev_x: float = 0.0
var prev_y: float = 0.0
var prev_z: float = 0.0
var last_offset: Vector3 = Vector3(0,0,0)

var original_translation: Vector3 = Vector3()

func _ready() -> void:
	original_translation = get_translation()

func _process(delta: float) -> void:
	if timer == 0:
		set_translation(original_translation)
		set_process(false)
		return
	last_shook_timer = last_shook_timer + delta
	while last_shook_timer >= period_in_ms:
		last_shook_timer = last_shook_timer - period_in_ms
		# Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
		var intensity = amplitude * (1 - ((duration - timer) / duration))
		# Noise calculation logic from http://jonny.morrill.me/blog/view/14
		var new_x = rand_range(-1.0, 1.0)
		var x_offset = intensity * (prev_x + (delta * (new_x - prev_x)))
		var new_y = rand_range(-1.0, 1.0)
		var y_offset = intensity * (prev_y + (delta * (new_y - prev_y)))

		var new_z = rand_range(-1.0, 1.0)
		var z_offset = intensity * (prev_z + (delta * (new_z - prev_z)))

		prev_x = new_x
		prev_y = new_y
		prev_z = new_z
		# Track how much we've moved the offset, as opposed to other effects.
		var new_offset = Vector3(x_offset, y_offset, z_offset)
		#set_offset(get_offset() - _last_offset + new_offset)
		set_translation(get_translation() - last_offset + new_offset)
		last_offset = new_offset
	# Reset the offset when we're done shaking.
	timer = timer - delta
	if timer <= 0:
		timer = 0
		set_translation(get_translation() - last_offset)

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func shake(duration: float, frequency: float, amplitude: float):
	# Don't interrupt current shake duration
	if(timer != 0): return

	randomize()

	self.duration = duration
	timer = duration
	period_in_ms = 1.0 / frequency
	self.amplitude = amplitude
	prev_x = rand_range(-1.0, 1.0)
	prev_y = rand_range(-1.0, 1.0)
	last_offset = Vector3(0, 0, 0)

	set_translation(original_translation)
	set_process(true)
