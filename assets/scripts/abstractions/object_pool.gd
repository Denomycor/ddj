class_name ObjectPool extends RefCounted


var buffer: Array[Variant] = []
var max_size: int
var constructor: Callable

var current := 0


func _init(max_s: int, ctor: Callable) -> void:
	max_size = max_s
	constructor = ctor


func request() -> Variant:
	if(current > 0):
		current -= 1
		return buffer.pop_back()
	else:
		return constructor.call()


func dispose(value: Variant) -> void:
	if(current < max_size):
		buffer.append(value)
		current += 1
	else:
		value.queue_free()


## Destructor
func _notification(what: int) -> void:
	if(what == NOTIFICATION_PREDELETE):
		for e in buffer:
			if(e != null && e.get_parent() != null):
				e.free()

