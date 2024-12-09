class_name Troop extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	var target := perception_component.get_closest_target()
	if(target):
		(target.get_node("HitboxComponent") as HitboxComponent).deal_damage(1)

