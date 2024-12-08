## Defines the hitbox area to the troop and provides logic to handle hp and damage
class_name HitboxComponent extends Area2D

signal hit(value: int)
signal died

@export var max_hp := 100

var current_hp = max_hp


func deal_damage(value: int) -> void:
	if(current_hp > value):
		current_hp -= value
		hit.emit(value)
	else:
		current_hp = 0
		hit.emit(value)
		died.emit()

