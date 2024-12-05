## Implements a basic state machine
class_name StateMachine extends RefCounted


var all_states := {}

var current_state: State
var previous_state: State
var owner: Object


func _init(o: Object) -> void:
	owner = o


## Adds state to the state machine
func add_state(state: State) -> void:
	all_states[state.name] = state
	state._state_machine = weakref(self)
	state.owner = owner
	state.prepare()


## Must be called by the state machine owner to propagate _physics_process to states
func physics_process(delta: float) -> void:
	assert(current_state, "No current state")
	current_state.physics_process(delta)



## Must be called by the state machine owner to propagate _process to states
func process(delta: float) -> void:
	assert(current_state, "No current state")
	current_state.process(delta)


## Must be called by the state machine owner to propagate _input to states
func input(event: InputEvent) -> void:
	assert(current_state, "No current state")
	current_state.input(event)


## Transitions the state machine to the next state, from code outside of the state machine itself
func external_transition(next_state_key: String, args = null) -> void:
	var next_state: State = all_states[next_state_key]
	previous_state = current_state
	previous_state.exit(next_state)
	current_state = next_state
	next_state.enter(previous_state, args)


## Transitions the state machine to the next state, ignored if it's already on state
func transition(from: State, next_state_key: String, args = null) -> void:
	if(current_state == from):
		external_transition(next_state_key, args)


## Starts the state machine on the designated state
func starting_state(starting_state_key: String, args = null, call_enter := true) -> void:
	current_state = all_states[starting_state_key]
	if(call_enter):
		current_state.enter(null, args)


## Destructor, free states
func _notification(what: int) -> void:
	if(what == NOTIFICATION_PREDELETE):
		for e in all_states.values():
			e.free()
