## Defines the hitbox area to the troop and provides logic to handle hp and damage
class_name HitboxComponent extends Area2D

signal hit(value: float)
signal died

@export var max_hp := 100.0

var current_hp := max_hp

var hp_bar_tween: Tween

func _ready() -> void:
	var hp_bar: ProgressBar = get_node_or_null("../hp_bar")
	if(hp_bar):
		hp_bar.max_value = max_hp
		hp_bar.value = max_hp
		hp_bar.visible = false
		hit.connect(func(value: float):
			hp_bar.value -= value
			hp_bar.visible = true
			if(hp_bar_tween != null && hp_bar_tween.is_valid()):
				hp_bar_tween.kill()
			hp_bar_tween = create_tween()
			hp_bar_tween.tween_callback(func(): hp_bar.visible = false).set_delay(1)
		)


func deal_damage(value: float) -> void:
	if(current_hp > value):
		current_hp -= value
		hit.emit(value)
	else:
		current_hp = 0
		hit.emit(value)
		print("died")
		died.emit()
