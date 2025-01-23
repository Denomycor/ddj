class_name Level extends Node2D

signal level_quited(level: Node2D)

var game_ended := false

func _process(_delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("enemy_troops")
	var allies := get_tree().get_nodes_in_group("player_troops")

	if(enemies.is_empty()):
		var menu := get_node("mission_acomplished")
		menu.visible = true
		get_tree().paused = true
		game_ended = true
		menu.get_node("VBoxContainer/quit").pressed.connect(level_quited.emit.bind(self))
	elif(allies.is_empty()):
		var menu := get_node("game_over")
		menu.visible = true
		get_tree().paused = true
		game_ended = true
		menu.get_node("VBoxContainer/quit").pressed.connect(level_quited.emit.bind(self))
