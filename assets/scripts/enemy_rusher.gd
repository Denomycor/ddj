class_name EnemyRusher extends EnemyTroop


func _ready() -> void:
	super._ready()

	state_machine.add_state(IdleState.new("idle"))
	state_machine.add_state(Chase2State.new("chase"))
	state_machine.starting_state("wait", 1.0)


## Decide which state to transition to
func transition_rusher(state: State) -> void:
	var ranger_list := perception_component.enemies_in_range.filter(func(e): return e is TroopSniper)
	var has_ranger := !ranger_list.is_empty()

	# No enemies, stay put
	if(perception_component.enemies_in_range.is_empty()):
		if(state_machine.current_state.name != "idle"):
			state_machine.transition(state, "idle")

	# If a ranger is in range attack it
	elif(has_ranger):
		var nearest_ranger: Node2D = ranger_list.reduce(func(acc: Node2D, e: Node2D):
			return e if is_first_closer(e.global_position, acc.global_position) else acc
		, ranger_list[0])
		state_machine.transition(state, "chase", nearest_ranger)

	# If no ranger is in range attack any troop
	else:
		var nearest_target: Node2D = perception_component.get_closest_target()
		$Sprite2D.look_at(nearest_target.global_position)
		state_machine.transition(state, "chase", nearest_target)



### State overrides


## While Idle keep checking for transitions
class IdleState extends State:
	func process(_delta) -> void:
		(owner as EnemyTroop).transition_rusher(self)


## While Chasing try to attack the target
class Chase2State extends ChaseState:

	var attack_ready := true
	const ATTACK_DELAY := 1
	const ATTACK_DAMAGE := 70

	func leave_state() -> void:
		state_machine.transition(self, "wait", 0.2)

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
