class_name Troop extends CharacterBody2D

const PROJ_SCENE := preload("res://assets/scenes/projectiles/projectile.tscn")

var designation := "ranger"

@export var speed: float = 100.0  # Movement speed for the troop
@export var disperse_aprox_distance: float = 20.0  # Distance threshold for dispersion to be considered complete

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent
@onready var projectile_spawner_component: ProjectileSpawnerComponent = $ProjectileSpawnerComponent

var target_pos: Vector2 = Vector2.ZERO  # Default position for dispersal
var is_dispersing: bool = false  # Whether the troop is currently dispersing

func _ready() -> void:
	hitbox_component.died.connect(queue_free)
	hitbox_component.hit.connect(print)

	projectile_spawner_component.shoot_projectile.connect(func(from: Vector2, rot: float, _data: Variant):
		var instance: Projectile = PROJ_SCENE.instantiate()
		get_parent().add_child(instance)
		instance.set_properties_and_start(from, rot)
	)

func _process(_delta: float) -> void:
	# If dispersing, move toward the target position
	if is_dispersing:
		_move_towards_target(_delta)

	# Continue attacking logic if there's a target
	var target := perception_component.get_closest_target()
	if target:
		projectile_spawner_component.shoot(target.global_position)

# Function to set a new target position for dispersion
func disperse_to(random_pos: Vector2) -> void:
	target_pos = random_pos
	is_dispersing = true

# Internal function to handle movement toward the target position
func _move_towards_target(delta: float) -> void:
	if not is_dispersing:
		return
	
	var direction = (target_pos - global_position).normalized()
	position += direction * speed * delta

	# Check if the troop has reached the target position
	if global_position.distance_to(target_pos) <= disperse_aprox_distance:
		is_dispersing = false  # Stop dispersing once the target position is reached
