class_name Projectile extends CharacterBody2D


@export var speed := 300
@export var max_range := 10000
@export var damage := 1

var distance_acc := 0.0
var locked := true


func _ready() -> void:
	$Area2D.area_entered.connect(func(area: Area2D):
		print("Area Entered by:", area)
		if(area is HitboxComponent):
			print("Hitbox Detected! Applying Damage:", damage)
			area.deal_damage(damage)
			destroy()
		else:
			print("Non-Hitbox Area Detected:", area)
	)

func set_properties_and_start(from: Vector2, rot: float) -> void:
	print("Projectile start:", from, rot)
	global_position = from
	rotation = rot
	locked = false
	print("Projectile Initialized at:", global_position, "with rotation:", rotation)


func _physics_process(_delta: float) -> void:
	assert(!locked)
	var direction := Vector2.from_angle(rotation)
	var motion := direction * speed
	distance_acc += motion.length()

	if(distance_acc > max_range):
		destroy()
	else:
		velocity = motion
		var collision := move_and_collide(motion)
		if(collision):
			handle_collision(collision)


func handle_collision(_collision: KinematicCollision2D) -> void:
	print("Collision Detected with:", _collision.collider)
	destroy()


func destroy() -> void:
	queue_free()
