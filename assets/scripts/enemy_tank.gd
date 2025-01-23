class_name EnemyTank extends EnemyTroop


const RANGER_AWARENESS_RADIUS := 180


func _ready() -> void:
	super._ready()

	state_machine.add_state(IdleState.new("idle"))
	state_machine.add_state(Chase2State.new("chase"))
	state_machine.add_state(Protect2State.new("protect"))
	state_machine.starting_state("wait", 1.0)


func transition_tank(state: State) -> void:
	var nearest_threatened_ranger := get_nearest_threatened_ranger()

	# Bodyguard rangers
	if(nearest_threatened_ranger):
		state_machine.transition(state, "protect", nearest_threatened_ranger)

	# No enemies, stay put
	elif(perception_component.enemies_in_range.is_empty()):
		if(state_machine.current_state.name != "idle"):
			state_machine.transition(state, "idle")
	
	else:
		var nearest_target: Node2D = perception_component.get_closest_target()
		state_machine.transition(state, "chase", nearest_target)
		$Sprite2D.look_at(nearest_target.global_position)


## Get the neareast ranger in range that has enemies nearby
func get_nearest_threatened_ranger() -> EnemyRanger:
	var all_enemies := get_tree().get_nodes_in_group("enemy_troops")
	var rangers_nearby := all_enemies.filter(func(e: Node2D):
		return e is EnemyRanger && global_position.distance_to(e.global_position) < RANGER_AWARENESS_RADIUS
	)
	var rangers_threatened := rangers_nearby.filter(func(e: Node2D):
		return !(e as EnemyRanger).attack_range_component.enemies_in_range.is_empty()
	)
	if(rangers_threatened.is_empty()):
		return null
	else:
		return rangers_threatened.reduce(func(acc: Node2D, e: Node2D):
			return e if is_first_closer(e.global_position, acc.global_position) else acc
		, rangers_threatened[0])


### State overrides


## While Idle keep checking for transitions
class IdleState extends State:
	func process(_delta) -> void:
		(owner as EnemyTroop).transition_tank(self)


## While Chasing try to attack the target
class Chase2State extends ChaseState:

	var attack_ready := true
	const ATTACK_DELAY := 1
	const ATTACK_DAMAGE := 10

	func leave_state() -> void:
		state_machine.transition(self, "wait", 0.2)

	func prepare():
		super.prepare()
		troop.get_node("chase_timer").timeout.connect(leave_state)

	func enter(previous_state: State, args) -> void:
		super.enter(previous_state, args)
		troop.get_node("chase_timer").start()
	
	func exit(next_state: State) -> void:
		super.exit(next_state)
		troop.get_node("chase_timer").stop()

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



## While Protecting attack nearby targets
class Protect2State extends ProtectState:

	var attack_ready := true
	const ATTACK_DELAY := 1
	const ATTACK_DAMAGE := 10

	func leave_state() -> void:
		state_machine.transition(self, "wait", 0.2)


	func physics_process(delta: float) -> void:
		# attack
		var target := troop.attack_range_component.get_closest_target()
		if(target && attack_ready):
			target.get_node("HitboxComponent").deal_damage(ATTACK_DAMAGE)
			attack_ready = false
			var tween := troop.create_tween()
			tween.tween_callback(func(): attack_ready = true).set_delay(ATTACK_DELAY)

		# We move the entt here
		super.physics_process(delta)
