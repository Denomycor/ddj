class_name Troop extends CharacterBody2D

const PROJ_SCENE := preload("res://assets/scenes/projectiles/projectile.tscn")

@export var speed: float = 100.0  # Movement speed for the troop
@export var disperse_aprox_distance: float = 20.0  # Distance threshold for dispersion to be considered complete

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent
@onready var projectile_spawner_component: ProjectileSpawnerComponent = $Sprite2D/ProjectileSpawnerComponent
@onready var animation_player = self.get_node("AnimationPlayer")
@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var shoot_sfx: AudioStream
var target_pos: Vector2 = Vector2.ZERO  # Default position for dispersal
var is_dispersing: bool = false  # Whether the troop is currently dispersing

func _ready() -> void:
	hitbox_component.died.connect(queue_free)
	hitbox_component.hit.connect(print)
	
	projectile_spawner_component.shoot_projectile.connect(func(from: Vector2, rot: float, _data: Variant):
		#animação de disparo
		animation_player.play("shoot")
		animation_player.queue("RESET")
		load_sfx(shoot_sfx)
		sfx_player.play()
		
		var instance: Projectile = PROJ_SCENE.instantiate()
		get_parent().add_child(instance)
		instance.set_properties_and_start(from, rot)
	)

func _process(_delta: float) -> void:
	# Continue attacking logic if there's a target
	var target := perception_component.get_closest_target()
	if(target):
		look_at(target.global_position)
		projectile_spawner_component.shoot(target.global_position)

func load_sfx(sfx):
	if sfx_player.stream != sfx:
		sfx_player.stop()
		sfx_player.stream = sfx

# Function to set a new target position for dispersion
func disperse_to(random_pos: Vector2) -> void:
	print("Dispersing to:", random_pos)  # Debugging output to confirm target
	target_pos = random_pos
	is_dispersing = true
	navigation_agent.target_position = target_pos  # Use the navigation agent to set the target

func _physics_process(delta: float) -> void:
	# Update movement based on NavigationAgent2D
	if is_dispersing and navigation_agent.is_target_reached() == false:
		var velocity = navigation_agent.get_next_path_position() - global_position
		velocity = velocity.normalized() * speed
		position += velocity * delta

	# Check if the troop has reached the target
	if is_dispersing and navigation_agent.is_target_reached():
		print("Reached target position:", global_position)
		is_dispersing = false  # Stop dispersing
		navigation_agent.target_position = global_position  # Clear the target
