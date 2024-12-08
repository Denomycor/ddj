## Keeps track of what enemies are in range of this troop
class_name PerceptionComponent extends Area2D

## The vision range to register enemy troops
@export var perception_range: float

var enemies_in_range: Array[PhysicsBody2D]
var enabled = true


func _ready() -> void:
	$CollisionShape2D.shape.radius = perception_range
	body_entered.connect(enemies_in_range.append)
	body_exited.connect(enemies_in_range.erase)


func toggle_enabled(state: bool) -> void:
	monitoring = state
	enabled = state


func get_closest_target() -> PhysicsBody2D:
	if(enemies_in_range.is_empty()):
		return null
	else:
		return enemies_in_range.reduce(func(acc: PhysicsBody2D, e: PhysicsBody2D):
			return acc if global_position.distance_to(acc.global_position) < global_position.distance_to(e.global_position) else e
		, enemies_in_range[0])

