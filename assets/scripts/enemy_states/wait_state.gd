## Base class for waiting behavior, override to extends behavior and define transitions
class_name WaitState extends State


var troop: Node2D
var timer: Timer


func prepare() -> void:
	troop = owner as EnemyTroop
	timer = troop.get_node("activation_timer")


func enter(_previous_state: State, args) -> void:
	assert(args is float)
	timer.wait_time = args
	timer.timeout.connect(leave_state)
	timer.start()


func exit(_next_state: State) -> void:
	timer.stop()
	timer.timeout.disconnect(leave_state)


func leave_state() -> void:
	pass

