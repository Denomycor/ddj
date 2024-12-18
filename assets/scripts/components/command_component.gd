class_name CommandComponent extends Node

## The movement speed of this troop
@export var speed = 100;
## The distance within the target position in order to consider the target as reached
@export var aprox_distance = 100;

@onready var parent: Node = get_parent()

var command_state_machine := StateMachine.new(self)


func _ready() -> void:
	command_state_machine.add_state(MoveTo.new("move_to"))
	command_state_machine.add_state(State.new("no_command"))
	command_state_machine.starting_state("no_command")


func _physics_process(delta: float) -> void:
	get_node("../Label").text = command_state_machine.current_state.name
	command_state_machine.physics_process(delta)


## Get all command names available for this troop
func list_available_commands() -> Array:
	return command_state_machine.all_states.keys()

