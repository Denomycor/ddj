class_name Troop extends CharacterBody2D

const PROJ_SCENE := preload("res://assets/scenes/projectiles/projectile.tscn")

var designation := "ranger"

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent
@onready var projectile_spawner_component: ProjectileSpawnerComponent = $ProjectileSpawnerComponent


func _ready() -> void:
	projectile_spawner_component.shoot_projectile.connect(func(from: Vector2, rot: float, _data: Variant):
		var instance: Projectile = PROJ_SCENE.instantiate()
		get_parent().add_child(instance)
		instance.set_properties_and_start(from, rot)
	)


func _process(_delta: float) -> void:
	var target := perception_component.get_closest_target()
	if(target):
		projectile_spawner_component.shoot(target.global_position)

