class_name Projectile extends CharacterBody2D


@export var speed := 20
@export var max_range := 10000
@export var damage := 1

var distance_acc := 0.0
var locked := true

var motion := Vector2.ZERO
var lock_hit = false


func _ready() -> void:
	$Area2D.area_entered.connect(on_hit)
	$RayCast2D.add_exception(get_node("Area2D"))


func on_hit(area: Area2D) -> void:
	if(area is HitboxComponent && !lock_hit):
		area.deal_damage(damage)
		lock_hit = true
		destroy()



func set_properties_and_start(from: Vector2, rot: float) -> void:
	global_position = from
	rotation = rot
	locked = false

	var direction := Vector2.from_angle(rotation)
	motion = direction * speed
	$RayCast2D.target_position = Vector2.RIGHT * speed


func _physics_process(_delta: float) -> void:
	assert(!locked)
	lock_hit = false
	distance_acc += motion.length()

	# Ensure we won't skip the target the next frame
	$RayCast2D.force_raycast_update()
	var collider: Node2D = $RayCast2D.get_collider()
	if(collider):
		if(global_position.distance_to(collider.global_position) < max_range - distance_acc):
			on_hit(collider)

	# Check if we hit something this frame if range hasn't ended
	if(distance_acc > max_range):
		destroy()
	else:
		velocity = motion
		var collision := move_and_collide(motion)
		if(collision):
			handle_collision(collision)


func handle_collision(_collision: KinematicCollision2D) -> void:
	destroy()


func destroy() -> void:
	queue_free()

