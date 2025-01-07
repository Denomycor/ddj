class_name EnemyTroop extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent
@onready var attack_range_component: PerceptionComponent = $attack_range

@export var speed = 100;

var state_machine := StateMachine.new(self)


func _ready() -> void:
	hitbox_component.died.connect(queue_free)
	state_machine.add_state(Wait2State.new("wait"))


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)


func _process(delta: float) -> void:
	state_machine.process(delta)
	$Label.text = state_machine.current_state.name


func get_player_troops() -> Array[Node2D]:
	return get_tree().get_nodes_in_group("player_troops") as Array[Node2D]


func is_first_closer(st: Vector2, nd: Vector2) -> bool:
	return global_position.distance_squared_to(st) < global_position.distance_squared_to(nd)



### State overrides


## When timer finishes, go to idle
class Wait2State extends WaitState:
	func leave_state() -> void:
		state_machine.transition(self, "idle")

