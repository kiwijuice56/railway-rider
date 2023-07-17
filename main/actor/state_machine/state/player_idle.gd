class_name PlayerIdle
extends State

var player: Player

func _ready() -> void:
	# state_machine.controller is null until state_machine._ready() runs
	yield(get_tree().get_root(), "ready")
	player = state_machine.controller as Player

func enter(_data: Dictionary = {}) -> void:
	player.anim.play("idle")
