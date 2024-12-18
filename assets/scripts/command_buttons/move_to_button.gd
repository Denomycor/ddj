class_name MoveToButton extends CommandButton


var waiting_on_pos := false 


func _ready() -> void:
	pressed.connect(func():
		waiting_on_pos = true
		modulate = Color.GOLD
	)
	for e in get_parent().get_children().filter(func(e): return e != self):
		e.pressed.connect(func():
			waiting_on_pos = false
			modulate = Color.WHITE
		)
	

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		var e := event as InputEventMouseButton
		if(e.pressed && e.button_index == MOUSE_BUTTON_LEFT && waiting_on_pos):
			forward_command()


func forward_command() -> void:
	for_command_component(func(e): e.command_state_machine.external_transition(name, get_global_mouse_position()))


func toggle_enabled(state: bool) -> void:
	super.toggle_enabled(state)
	waiting_on_pos = false
	modulate = Color.WHITE

