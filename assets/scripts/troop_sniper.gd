class_name TroopSniper extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent
@onready var projectile_spawner_component: ProjectileSpawnerComponent = $Sprite2D/ProjectileSpawnerComponent
@onready var animation_player = self.get_node("AnimationPlayer")
@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer

@export var shoot_sfx: AudioStream

const PROJ_SCENE := preload("res://assets/scenes/projectiles/projectile.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	projectile_spawner_component.shoot_projectile.connect(func(from: Vector2, rot: float, _data: Variant):
		#animação de disparo
		animation_player.play("shoot")
		animation_player.queue("RESET")
		load_sfx(shoot_sfx)
		sfx_player.play()
		
		var instance: Projectile = PROJ_SCENE.instantiate()
		get_parent().add_child(instance)
		instance.speed = 20
		instance.max_range = 20000
		instance.damage = 5
		instance.set_properties_and_start(from, rot)
	)
func _process(_delta: float) -> void:
	var target := perception_component.get_closest_target()
	if(target):
		$Sprite2D.look_at(target.global_position)
		projectile_spawner_component.shoot(target.global_position)

func load_sfx(sfx):
	if sfx_player.stream != sfx:
		sfx_player.stop()
		sfx_player.stream = sfx
