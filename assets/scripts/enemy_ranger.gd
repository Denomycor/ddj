class_name EnemyRanger extends EnemyTroop


const PROJ_SCENE := preload("res://assets/scenes/projectiles/projectile.tscn")

@onready var projectile_spawner_component: ProjectileSpawnerComponent = $Sprite2D/ProjectileSpawnerComponent
@onready var animation_player = self.get_node("AnimationPlayer")

func _ready() -> void:
	super._ready()
	projectile_spawner_component.shoot_projectile.connect(func(from: Vector2, rot: float, _data: Variant):
		#animação de disparo
		animation_player.play("shoot")
		animation_player.queue("RESET")
		
		var instance: Projectile = PROJ_SCENE.instantiate()
		instance.set_collision_layer_value(3, false)
		instance.set_collision_layer_value(4, true)
		instance.get_node("Area2D").set_collision_layer_value(3, false)
		instance.get_node("Area2D").set_collision_layer_value(4, true)
		instance.get_node("Area2D").set_collision_mask_value(2, false)
		instance.get_node("Area2D").set_collision_mask_value(1, true)
		get_parent().add_child(instance)
		instance.set_properties_and_start(from, rot)
	)

	state_machine.add_state(IdleState.new("idle"))
	state_machine.add_state(AproachState.new("aproach"))
	state_machine.add_state(AttackState.new("attack"))
	state_machine.starting_state("wait", 1.0)


## Decide which state to transition to
func transition_ranger(state: State) -> void:
	# No enemies, stay put
	if(perception_component.enemies_in_range.is_empty()):
		if(state_machine.current_state.name != "idle"):
			state_machine.transition(state, "idle")

	# Enemies in range, just shoot
	elif(!attack_range_component.enemies_in_range.is_empty()):
		state_machine.transition(state, "attack")

	# Aproach the nearest enemy to attack
	elif(!perception_component.enemies_in_range.is_empty()):
		var nearest_target: Node2D = perception_component.get_closest_target()
		
		state_machine.transition(state, "aproach", nearest_target)

### State overrides

## While Idle keep checking for transitions
class IdleState extends State:
	func process(_delta) -> void:
		(owner as EnemyTroop).transition_ranger(self)


## While Chasing try to attack the target
class AproachState extends ChaseState:
	func leave_state() -> void:
		state_machine.transition(self, "wait", 0.2)

	func physics_process(delta: float) -> void:
		if(nav_agent.is_navigation_finished()):
			(owner as EnemyTroop).transition_ranger(self)
		super.physics_process(delta)
