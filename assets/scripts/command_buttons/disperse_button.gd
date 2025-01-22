class_name DisperseButton extends CommandButton

func _ready() -> void:
	pressed.connect(func():
		for_command_component(func(command_component):
			var selected_troops = selection_rect.selected_troops  # Get the selected troops
			command_component.command_state_machine.external_transition("disperse", selected_troops)  # Transition state with troops as argument
		)
	)

func toggle_enabled(state: bool) -> void:
	disabled = !state
	visible = state

func for_command_component(function: Callable) -> void:
	for troop in selection_rect.selected_troops:
		function.call(troop.get_node("CommandComponent"))
