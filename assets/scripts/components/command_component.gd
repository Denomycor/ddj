class_name CommandComponent extends Node

@onready var parent: Node = get_parent()

var command_state_machine := StateMachine.new(self)


func _ready() -> void:
	command_state_machine.add_state(MoveTo.new("move_to"))
	command_state_machine.add_state(State.new("no_command"))
	command_state_machine.starting_state("no_command")


func _physics_process(delta: float) -> void:
	command_state_machine.physics_process(delta)


func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		var e := event as InputEventMouseButton
		if(e.button_index == MOUSE_BUTTON_LEFT && !e.pressed):
			command_state_machine.external_transition("move_to", parent.get_global_mouse_position())

