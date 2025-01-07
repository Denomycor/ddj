class_name EnemyTroop extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent


func _ready() -> void:
	hitbox_component.died.connect(queue_free)
	hitbox_component.hit.connect(print)
