class_name HelpScreen
extends Control

func _ready() -> void:
	modulate.a = 0
	get_node("%BackButton").disabled = true
	visible = false
	
# warning-ignore:return_value_discarded
	get_node("%BackButton").connect("button_up", self, "_on_back_pressed")
	get_node("%MusicButton").connect("button_up", self, "_on_music_mute")
	get_node("%SfxButton").connect("button_up", self, "_on_sfx_mute")

func _on_back_pressed() -> void:
	get_node("%BackButton").disabled = true
	
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.3)
	$Tween.interpolate_property(get_node("../UIBlocker"), "modulate:a", 1.0, 0.0, 0.3)
	$Tween.start()
	visible = true
	yield($Tween, "tween_completed")
	get_node("../TitleScreen").enter()
	visible = false

func _on_music_mute() -> void:
	GlobalState.music_mute = not GlobalState.music_mute
	update_text()

func _on_sfx_mute() -> void:
	GlobalState.sfx_mute = not GlobalState.sfx_mute
	update_text()

func enter() -> void:
	update_text()
	$Tween.interpolate_property(get_node("../UIBlocker"), "modulate:a", 0.0, 1.0, 0.3)
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.3)
	$Tween.start()
	visible = true
	yield($Tween, "tween_completed")
	
	get_node("%BackButton").disabled = false
	get_node("%BackButton").grab_focus()

func update_text() -> void:
	get_node("%MusicButton").text = "Mute music" if not GlobalState.music_mute else "Unmute music"
	get_node("%SfxButton").text = "Mute sfx" if not GlobalState.sfx_mute else "Unmute sfx"
