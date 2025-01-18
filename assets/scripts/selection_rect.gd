class_name SelectionRect extends CanvasLayer

var start_point: Vector2
var end_point: Vector2
var is_selecting := false

var selected_troops: Array


func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		var e := event as InputEventMouseButton
		if(e.pressed && e.button_index == MOUSE_BUTTON_RIGHT):
			start_rect()
		if(!e.pressed && e.button_index == MOUSE_BUTTON_RIGHT):
			end_rect()

	if(event is InputEventMouseMotion && is_selecting):
		update_rect()


func start_rect() -> void:
	start_point = get_parent().get_global_mouse_position()
	for t in selected_troops:
		if(is_instance_valid(t)):
			t.get_node("Polygon2D").color = Color.WHITE
	update_command_ui([])
	selected_troops = []
	is_selecting = true


func end_rect() -> void:
	is_selecting = false
	$Panel.visible = false


func update_rect() -> void:
	$Panel.visible = true
	end_point = get_parent().get_global_mouse_position()

	var corner := start_point.min(end_point)
	var size := (start_point-end_point).abs()

	$Panel.global_position = corner
	$Panel.size = size

	var rect := Rect2(corner, size)

	for t in selected_troops:
		t.get_node("Polygon2D").color = Color.WHITE
	selected_troops = get_tree().get_nodes_in_group("player_troops").filter(func(e: Troop):
		return rect.has_point(e.global_position)
	)
	for t in selected_troops:
		t.get_node("Polygon2D").color = Color.BLUE
	
	handle_selection()
	

# TODO: temp
func forward_command() -> void:
	for e in selected_troops:
		e.get_node("CommandComponent").command_state_machine.external_transition("move_to", get_parent().get_global_mouse_position())


func handle_selection() -> void:
	var all_commands: Array[String] = []
	for t in selected_troops:
		for c in t.get_node("CommandComponent").list_available_commands():
			if(!all_commands.has(c)):
				all_commands.push_back(c)
	update_command_ui(all_commands)


func update_command_ui(commands: Array[String]) -> void:
	var labels := get_node("../UI/HBoxContainer").get_children()
	for l: CommandButton in labels:
		if(commands.has(l.name)):
			l.toggle_enabled(true)
		else:
			l.toggle_enabled(false)
