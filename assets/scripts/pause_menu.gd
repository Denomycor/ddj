class_name PauseMenu extends CanvasLayer



func _ready() -> void:
	$VBoxContainer/resume.pressed.connect(toggle_paused.bind(false))
	$VBoxContainer/quit.pressed.connect(get_parent().level_quited.emit.bind(get_parent()))
	

func toggle_paused(value: bool) -> void:
	visible = value
	get_tree().paused = value


func _input(event: InputEvent) -> void:
	if(event is InputEventKey):
		var e := event as InputEventKey
		if(e.get_keycode_with_modifiers() == KEY_ESCAPE && e.pressed && !get_parent().game_ended):
			toggle_paused(!visible)

