## Defines the hitbox area to the troop and provides logic to handle hp and damage
class_name HitboxSniperComponent extends Area2D

signal hit(value: float)
signal died

@export var max_hp := 50.0

var current_hp := max_hp


func deal_damage(value: float) -> void:
	print("Deal Damage Called on Sniper Hitbox with value:", value)
	if(current_hp > value):
		current_hp -= value
		hit.emit(value)
	else:
		current_hp = 0
		hit.emit(value)
		died.emit()
