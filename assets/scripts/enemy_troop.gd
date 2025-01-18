class_name EnemyTroop extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var perception_component: PerceptionComponent = $PerceptionComponent
@onready var attack_range_component: PerceptionComponent = $attack_range

@export var speed = 100;

var state_machine := StateMachine.new(self)

func _ready() -> void:
	hitbox_component.died.connect(queue_free)

	state_machine.add_state(Wait2State.new("wait"))
	state_machine.add_state(IdleState.new("idle"))
	state_machine.add_state(Chase2State.new("chase"))
	state_machine.starting_state("wait", 1.0)


## Decide which state to transition to
func transition_rusher(state: State) -> void:
	var ranger_list := perception_component.enemies_in_range.filter(func(e): return e.designation == "ranger")
	var has_ranger := !ranger_list.is_empty()

	# No enemies, stay put
	if(perception_component.enemies_in_range.is_empty()):
		if(state_machine.current_state.name != "idle"):
			state_machine.transition(state, "idle")

	# If a ranger is in range attack it
	if(has_ranger):
		var nearest_ranger: Node2D = ranger_list.reduce(func(acc: Node2D, e: Node2D):
			return e if is_first_closer(e.global_position, acc.global_position) else acc
		, ranger_list[0])
		state_machine.transition(state, "chase", nearest_ranger)

	# If no ranger is in range attack any troop
	else:
		var nearest_target: Node2D = perception_component.enemies_in_range.reduce(func(acc: Node2D, e: Node2D):
			return e if is_first_closer(e.global_position, acc.global_position) else acc
		, perception_component.enemies_in_range[0])
		state_machine.transition(state, "chase", nearest_target)


func _physics_process(delta: float) -> void:
	state_machine.physics_process(delta)


func _process(delta: float) -> void:
	state_machine.process(delta)


func get_player_troops() -> Array[Node2D]:
	return get_tree().get_nodes_in_group("player_troops") as Array[Node2D]


func is_first_closer(st: Vector2, nd: Vector2) -> bool:
	return global_position.distance_squared_to(st) < global_position.distance_squared_to(nd)



### State overrides


## When timer finishes, go to idle
class Wait2State extends WaitState:
	func leave_state() -> void:
		state_machine.transition(self, "idle")


## While Idle keep checking for transitions
class IdleState extends State:
	func process(_delta) -> void:
		(owner as EnemyTroop).transition_rusher(self)


## While Chasing try to attack the target
class Chase2State extends ChaseState:

	var attack_ready := true
	const ATTACK_DELAY := 1
	const ATTACK_DAMAGE := 1

	func leave_state() -> void:
		(owner as EnemyTroop).transition_rusher(self)

	func physics_process(delta: float) -> void:
		if(!troop.perception_component.overlaps_body(target)):
			leave_state()
			return

		# We move the entt here
		super.physics_process(delta)
		
		# attack
		if(troop.attack_range_component.overlaps_body(target) && attack_ready):
			target.get_node("HitboxComponent").deal_damage(ATTACK_DAMAGE)
			attack_ready = false
			var tween := troop.create_tween()
			tween.tween_callback(func(): attack_ready = true).set_delay(ATTACK_DELAY)

