class_name Projectile extends CharacterBody2D

@export var speed := 20
@export var max_range := 10000
@export var damage := 40

var distance_acc := 0.0
var locked := true


func set_properties_and_start(from: Vector2, rot: float) -> void:
	global_position = from
	rotation = rot
	locked = false

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


func handle_collision(collision: KinematicCollision2D) -> void:
	var entt = collision.get_collider()
	if(entt is Node):
		var hitbox_component: HitboxComponent = entt.get_node_or_null("HitboxComponent")
		if(hitbox_component):
			hitbox_component.deal_damage(damage)
	destroy()


func destroy() -> void:
	queue_free()
