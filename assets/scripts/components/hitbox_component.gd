## Defines the hitbox area to the troop and provides logic to handle hp and damage
class_name HitboxComponent extends Area2D

signal hit(value: float)
signal died

@export var max_hp := 100.0

var current_hp := max_hp


func deal_damage(value: float) -> void:
	if(current_hp > value):
		current_hp -= value
		hit.emit(value)
	else:
		current_hp = 0
		hit.emit(value)
		died.emit()
