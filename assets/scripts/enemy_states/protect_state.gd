class_name ProtectState extends State

const PROTECT_DISTANCE := 25

var troop: EnemyTroop
var protect_target: EnemyTroop
var nav_agent: NavigationAgent2D


func prepare() -> void:
	troop = owner as EnemyTroop
	nav_agent = troop.get_node("NavigationAgent2D")


func enter(_previous_state: State, args) -> void:
	assert(args is EnemyTroop)
	protect_target = args
	# nav_agent.velocity_computed.connect(_on_velocity_computed)
	protect_target.get_node("HitboxComponent").died.connect(leave_state)
	calculate_path()
	nav_agent.get_node("Timer").timeout.connect(calculate_path)
	nav_agent.get_node("Timer").start()


func physics_process(_delta: float) -> void:
	if(protect_target.attack_range_component.enemies_in_range.is_empty()):
		leave_state()

	elif(!nav_agent.is_navigation_finished()):
		var next_point := nav_agent.get_next_path_position()
		var motion: Vector2 = troop.global_position.direction_to(next_point) * troop.speed
		_on_velocity_computed(motion)
		# nav_agent.set_velocity(motion)


func exit(_next_state: State) -> void:
	# nav_agent.velocity_computed.disconnect(_on_velocity_computed)
	nav_agent.get_node("Timer").stop()
	nav_agent.get_node("Timer").timeout.disconnect(calculate_path)
	protect_target.get_node("HitboxComponent").died.disconnect(leave_state)


func _on_velocity_computed(velocity: Vector2) -> void:
	troop.velocity = velocity
	troop.move_and_slide()


func calculate_path() -> void:
	nav_agent.set_target_position(get_protect_position())
	if(!nav_agent.is_target_reachable()):
		print("Impossible to reach the target")


func leave_state() -> void:
	pass


func get_protect_position() -> Vector2:
	var enemy_pos := protect_target.perception_component.get_closest_target().global_position
	var direction := protect_target.global_position.direction_to(enemy_pos)
	return protect_target.global_position + direction * PROTECT_DISTANCE

