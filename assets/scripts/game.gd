class_name Game extends Node

const TEST_LEVEL := preload("res://assets/scenes/test_level.tscn")
@onready var animation_player = $main_menu/VBoxContainer/AnimationPlayer

func _ready() -> void:
	$main_menu/VBoxContainer/play.pressed.connect(switch_from_main_menu_to_test_level)
	$main_menu/VBoxContainer/quit.pressed.connect(get_tree().quit)
	get_tree().paused = false  # Garante que o jogo não está pausado no menu


func switch_from_main_menu_to_test_level() -> void:
	var level := TEST_LEVEL.instantiate()
	level.level_quited.connect(switch_from_level_to_main_menu)
	$main_menu.visible = false
	add_child(level)


func switch_from_level_to_main_menu(level: Node2D) -> void:
	level.queue_free()
	get_tree().paused = false
	$main_menu.visible = true
	
func _on_play_mouse_entered() -> void:
	animation_player.play("shoot")
	
func _on_quit_mouse_entered() -> void:
	animation_player.play("shoot")
