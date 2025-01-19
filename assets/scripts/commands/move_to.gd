class_name MoveTo extends State

const MAX_MOVE_TIME := 20

var target_pos: Vector2
var troop: CharacterBody2D
var tween: Tween


func prepare() -> void:
	troop = owner.parent

		
func enter(_previous_state: State, args) -> void:
	assert(args is Vector2)
	target_pos = args
	tween = owner.create_tween()
	tween.tween_callback(leave_command).set_delay(MAX_MOVE_TIME)


func physics_process(_delta: float) -> void:
	if(troop.global_position.distance_to(target_pos) > owner.aprox_distance):
		var vec_to_target: Vector2 = troop.global_position.direction_to(target_pos)
		troop.velocity = vec_to_target * owner.speed
		troop.move_and_slide()
	else:
		leave_command()


func exit(_next_state: State) -> void:
	troop.velocity = Vector2.ZERO
	if(tween.is_valid()):
		tween.kill()


func leave_command() -> void:
	state_machine.transition(self, "no_command")
