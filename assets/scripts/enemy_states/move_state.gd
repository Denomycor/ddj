class_name MoveState extends State


var troop: EnemyTroop
var nav_agent: NavigationAgent2D
var target_pos: Vector2


func prepare() -> void:
	troop = owner as EnemyTroop
	nav_agent = troop.get_node("NavigationAgent2D")


func enter(_previous_state: State, args) -> void:
	assert(args is Vector2)
	target_pos = args
	# nav_agent.velocity_computed.connect(_on_velocity_computed)

func physics_process(_delta: float) -> void:
	if(nav_agent.is_navigation_finished()):
		leave_state()
	else:
		var next_point := nav_agent.get_next_path_position()
		var motion: Vector2 = troop.global_position.direction_to(next_point) * troop.speed
		_on_velocity_computed(motion)
		# nav_agent.set_velocity(motion)


func _on_velocity_computed(velocity: Vector2) -> void:
	troop.velocity = velocity
	troop.move_and_slide()


func calculate_path() -> void:
	nav_agent.set_target_position(target_pos)
	if(!nav_agent.is_target_reachable()):
		print("Impossible to reach the target")


func leave_state() -> void:
	pass

