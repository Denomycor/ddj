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
	
	selected_troops = get_tree().get_nodes_in_group("player_troops").filter(func(e: Troop):
		return rect.has_point(e.global_position)
	)
	
