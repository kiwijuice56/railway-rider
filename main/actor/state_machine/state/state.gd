class_name State
extends Node

signal transitioned

# Cannot have StateMachine type due to cyclical reference error
onready var state_machine: Node = get_parent()

func enter(_data: Dictionary = {}) -> void:
	pass

func exit(_data: Dictionary = {}) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func input(_event: InputEvent) -> void:
	pass
