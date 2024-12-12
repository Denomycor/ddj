class_name SelectionRect extends CanvasLayer

var start_point: Vector2
var end_point: Vector2
var is_selecting := false
var selection_valid := false

var selected_troops: Array


func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		var e := event as InputEventMouseButton
		selection_valid = false
		if(e.pressed && e.button_index == MOUSE_BUTTON_RIGHT):
			start_rect()
		if(!e.pressed && e.button_index == MOUSE_BUTTON_RIGHT):
			end_rect()

	if(event is InputEventMouseMotion && is_selecting):
		update_rect()


func start_rect() -> void:
	print("start")
	start_point = get_parent().get_global_mouse_position()
	is_selecting = true


func end_rect() -> void:
	print("end")
	is_selecting = false
	selection_valid = true
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
	
