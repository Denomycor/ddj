## Base class for following a target, override to extends behavior and define transitions
class_name ChaseState extends State


var troop: EnemyTroop
var target: Node2D
var nav_agent: NavigationAgent2D


func prepare() -> void:
	troop = owner as EnemyTroop
	nav_agent = troop.get_node("NavigationAgent2D")


func enter(_previous_state: State, args) -> void:
	assert(args is Node2D)
	target = args
	# nav_agent.velocity_computed.connect(_on_velocity_computed)
	target.get_node("HitboxComponent").died.connect(leave_state)
	calculate_path()
	nav_agent.get_node("Timer").timeout.connect(calculate_path)
	nav_agent.get_node("Timer").start()


func physics_process(_delta: float) -> void:
	if(!nav_agent.is_navigation_finished()):
		var next_point := nav_agent.get_next_path_position()
		var motion: Vector2 = troop.global_position.direction_to(next_point) * troop.speed
		_on_velocity_computed(motion)
		# nav_agent.set_velocity(motion)


func exit(_next_state: State) -> void:
	nav_agent.velocity_computed.disconnect(_on_velocity_computed)
	nav_agent.get_node("Timer").stop()
	nav_agent.get_node("Timer").timeout.disconnect(calculate_path)
	target.get_node("HitboxComponent").died.disconnect(leave_state)


func _on_velocity_computed(velocity: Vector2) -> void:
	troop.velocity = velocity
	troop.move_and_slide()


func calculate_path() -> void:
	nav_agent.set_target_position(target.global_position)
	if(!nav_agent.is_target_reachable()):
		print("Impossible to reach the target")


func leave_state() -> void:
	pass

