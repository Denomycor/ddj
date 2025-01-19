class_name CommandComponent extends Node

@export var speed = 100
@export var aprox_distance = 100

@onready var parent: Node = get_parent()

var command_state_machine := StateMachine.new(self)

func _ready() -> void:
	command_state_machine.add_state(MoveTo.new("move_to"))
	command_state_machine.add_state(State.new("no_command"))
	command_state_machine.add_state(DisperseState.new("disperse"))
	command_state_machine.starting_state("no_command")

func _physics_process(delta: float) -> void:
	get_node("../Label").text = command_state_machine.current_state.name
	command_state_machine.physics_process(delta)

func list_available_commands() -> Array:
	return command_state_machine.all_states.keys()
