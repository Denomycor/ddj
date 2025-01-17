class_name EnemyTroop extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent
@onready var attack_range_component: PerceptionComponent = $attack_range

@export var speed = 100;

var state_machine := StateMachine.new(self)

func _ready() -> void:
	hitbox_component.died.connect(queue_free)
	hitbox_component.hit.connect(print)

	state_machine.add_state(State.new("idle"))
	state_machine.add_state(ChaseState.new("chase"))
	state_machine.starting_state("idle")
	var tween := create_tween()
	tween.tween_callback(transition.bind(state_machine.current_state)).set_delay(2) # TODO: TEMP


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)


func _process(delta: float) -> void:
	state_machine.process(delta)


func get_player_troops() -> Array[Node2D]:
	return get_tree().get_nodes_in_group("player_troops") as Array[Node2D]


func transition(state: State) -> void:
	var ranger_list := perception_component.enemies_in_range.filter(func(e): return e.designation == "ranger")
	var has_ranger := !ranger_list.is_empty()

	# If a ranger is in range attack it
	if(has_ranger):
		var nearest_ranger: Node2D = ranger_list.reduce(func(acc: Node2D, e: Node2D):
			return e if is_first_closer(e.global_position, acc.global_position) else acc
		, ranger_list[0])
		state_machine.transition(state, "chase", nearest_ranger)

	# If no ranger is in range attack any troop
	else:
		state_machine.transition(state, "attack")


func is_first_closer(st: Vector2, nd: Vector2) -> bool:
	return global_position.distance_squared_to(st) < global_position.distance_squared_to(nd)
