class_name TroopSniper extends CharacterBody2D

@onready var hitbox_component: HitboxSniperComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent
@onready var projectile_spawner_component: ProjectileSpawnerSniperComponent = $ProjectileSpawnerComponent

const PROJ_SCENE := preload("res://assets/scenes/projectiles/projectile.tscn")

func _ready() -> void:
	projectile_spawner_component.shoot_projectile.connect(func(from: Vector2, rot: float, _data: Variant):
		var instance: Projectile = PROJ_SCENE.instantiate()
		get_parent().add_child(instance)
		instance.speed = 40
		instance.max_range = 20000
		instance.damage = 5
		instance.set_properties_and_start(from, rot)
	)


func _process(_delta: float) -> void:
	var target := perception_component.get_closest_target()
	if(target):
		projectile_spawner_component.shoot(target.global_position)

