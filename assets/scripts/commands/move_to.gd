class_name MoveTo extends State

var target_pos: Vector2


func enter(_previous_state: State, args) -> void:
	assert(args is Vector2)
	target_pos = args


func physics_process(_delta: float) -> void:
	if(owner.global_position.distance_to(target_pos) > owner.aprox_distance):
		var vec_to_target: Vector2 = owner.global_position.direction_to(target_pos)
		owner.velocity = vec_to_target * owner.speed
		owner.move_and_slide()
	else:
		state_machine.transition(self, "no_command")

