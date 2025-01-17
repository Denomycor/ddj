## On idle all enemy troops keep checking the behavior they are going to take
class_name IdleState extends State


var troop: Node2D


func prepare() -> void:
	troop = owner as EnemyTroop


func process(_delta: float) -> void:
	troop.transition(self)

