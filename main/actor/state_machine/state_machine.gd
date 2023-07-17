class_name StateMachine
extends Node

export var controller_path: NodePath
export var initial_state_name: String

var controller: Actor 
var active_state: State

func _ready() -> void:
	controller = get_node(controller_path)
	
	# Wait until entire tree is ready before processing state
	yield(get_tree().get_root(), "ready")
	if initial_state_name == "":
		return
	transition_to(initial_state_name)

func _physics_process(delta: float) -> void:
	if active_state == null:
		return
	active_state.physics_process(delta)

func _input(event: InputEvent) -> void:
	if active_state == null:
		return
	active_state.input(event)

func transition_to(state_name: String, data: Dictionary = {}) -> void:
	var to_state: State = get_node(state_name)
	
	# active_state is null when the state machine initializes
	if is_instance_valid(active_state):
		active_state.exit(data)
		yield(active_state, "transitioned")
		data.previous_state = active_state.name
	else:
		data.previous_state = ""
	active_state = to_state
	to_state.enter(data)
	yield(to_state, "transitioned")
