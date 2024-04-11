extends CharacterBody2D

var speed = 300

func get_input():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	print(velocity.length())

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
