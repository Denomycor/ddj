class_name AttackState extends State


var troop: EnemyTroop


func prepare() -> void:
	troop = owner as EnemyTroop


func physics_process(_delta: float) -> void:
	var nearest_target: Node2D = troop.attack_range_component.get_closest_target()
	if(nearest_target):
		troop.get_node("Sprite2D").look_at(nearest_target.global_position)
		troop.projectile_spawner_component.shoot(nearest_target.global_position)
	else:
		state_machine.transition(self,"wait", 0.2)

