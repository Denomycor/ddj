class_name DisperseButton extends CommandButton

func _ready() -> void:
	pressed.connect(func():
		for_command_component(func(command_component):
			var selected_troops = selection_rect.selected_troops  # Obtém as tropas selecionadas
			command_component.command_state_machine.external_transition("disperse", selected_troops)  # Transição de estado com tropas como argumento
		)
	)

func toggle_enabled(state: bool) -> void:
	disabled = !state
	visible = state

func for_command_component(function: Callable) -> void:
	for troop in selection_rect.selected_troops:
		function.call(troop.get_node("CommandComponent"))
