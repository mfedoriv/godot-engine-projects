extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 40
@export var follow_length := 100

var player = get_tree().get_first_node_in_group('Player')


func enter():
	pass

func physics_update(delta: float):
	var direction = player.global_position - enemy.global_position
	
	if direction.length() < follow_length:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
