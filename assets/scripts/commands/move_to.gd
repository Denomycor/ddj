class_name MoveTo extends State

var target_pos: Vector2
var troop: Troop


func enter(_previous_state: State, args) -> void:
	assert(args is Vector2)
	target_pos = args
	troop = owner.parent


func physics_process(_delta: float) -> void:
	if(troop.global_position.distance_to(target_pos) > troop.aprox_distance):
		var vec_to_target: Vector2 = troop.global_position.direction_to(target_pos)
		troop.velocity = vec_to_target * troop.speed
		troop.move_and_slide()
	else:
		state_machine.transition(self, "no_command")

