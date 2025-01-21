class_name TroopTank extends CharacterBody2D
#MUDAR!!
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent
@onready var projectile_spawner_component: ProjectileSpawnerComponent = $ProjectileSpawnerComponent
@onready var animation_player = self.get_node("AnimationPlayer")

const PROJ_SCENE := preload("res://assets/scenes/projectiles/projectile.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	projectile_spawner_component.shoot_projectile.connect(func(from: Vector2, rot: float, _data: Variant):
		#animação de disparo
		animation_player.play("shoot")
		
		var instance: Projectile = PROJ_SCENE.instantiate()
		get_parent().add_child(instance)
		instance.speed = 20
		instance.max_range = 20000
		instance.damage = 2
		instance.set_properties_and_start(from, rot)
	)
func _process(_delta: float) -> void:
	var target := perception_component.get_closest_target()
	if(target):
		projectile_spawner_component.shoot(target.global_position)
