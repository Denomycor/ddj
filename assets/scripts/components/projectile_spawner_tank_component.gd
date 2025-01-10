class_name ProjectileSpawnerTankComponent extends Node2D


signal shoot_projectile(from: Vector2, rot: float, data: Variant)
signal projectile_ready

@export var fire_delay: float = 1.0  #disparo medio delay
@export var multishot: int = 2  #2 projét1is de vez
@export var spread: float = 1.0  #variar o ângulo de disparo

var delay_acc: float
var proj_ready := true
var enabled := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delay_acc = fire_delay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !proj_ready:
		if delay_acc < delta:
			proj_ready = true
			projectile_ready.emit()
		else:
			delay_acc -= delta

func shoot(to: Vector2, data: Variant = null) -> void:
	if proj_ready and enabled:
		for i in range(multishot):
			var angle: float = (to - global_position).angle()
			shoot_projectile.emit(global_position, angle, data)
		proj_ready = false
		delay_acc = fire_delay
