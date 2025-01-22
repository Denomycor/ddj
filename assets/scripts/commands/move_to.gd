class_name MoveTo extends State

const MAX_MOVE_TIME := 20

var target_pos: Vector2
var troop: CharacterBody2D
var nav_agent: NavigationAgent2D
var tween: Tween


func prepare() -> void:
	troop = owner.parent
	nav_agent = troop.get_node("NavigationAgent2D") #novo

		
func enter(_previous_state: State, args) -> void:
	assert(args is Vector2)
	target_pos = args
	
	nav_agent.set_target_position(target_pos)#novo

	
	tween = owner.create_tween()
	tween.tween_callback(leave_command).set_delay(MAX_MOVE_TIME)


func physics_process(_delta: float) -> void:
	if !nav_agent.is_navigation_finished():#novo
		var next_point := nav_agent.get_next_path_position()#novo
		var motion: Vector2 = troop.global_position.direction_to(next_point) * owner.speed#novo
		_on_velocity_computed(motion)#novo
	else:
		leave_command()


func exit(_next_state: State) -> void:
	troop.velocity = Vector2.ZERO
	if(tween.is_valid()):
		tween.kill()

func _on_velocity_computed(velocity: Vector2) -> void:#novo
	troop.velocity = velocity
	troop.move_and_slide()

func leave_command() -> void:
	state_machine.transition(self, "no_command")
