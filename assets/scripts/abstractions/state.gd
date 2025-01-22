## Base State object for state machine implementation (Relies on State Machine to be freed)
class_name State extends Object


var _state_machine: WeakRef
var name: String
var owner: Object

var state_machine: StateMachine:
	get: 
		return _state_machine.get_ref()


func _init(n: String) -> void:
	name = n


## Called after state object is created, used to setup refereces and/or initialize dependencies
func prepare() -> void:
	pass


## Called everytime the state machine enters this state
func enter(_previous_state: State, _args) -> void:
	pass


## Called everytime the state machine exits this state
func exit(_next_state: State) -> void:
	pass


## Propagated by state machine _physics_process
func physics_process(_delta: float) -> void:
	pass


## Propagated by state machine _process
func process(_delta: float) -> void:
	pass


## Propagated by state machine _input
func input(_event: InputEvent) -> void:
	pass
