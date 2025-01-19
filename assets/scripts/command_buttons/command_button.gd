class_name CommandButton extends Button


@onready var selection_rect: SelectionRect = get_node("../../../selection_rect")


func _ready() -> void:
	pressed.connect(func():
		for_command_component(func(e): e.command_state_machine.external_transition(name))
	)


func toggle_enabled(state: bool) -> void:
	disabled = !state
	visible = state


func for_command_component(function: Callable) -> void:
	for e in selection_rect.selected_troops:
		if(is_instance_valid(e)):
			function.call(e.get_node("CommandComponent"))
