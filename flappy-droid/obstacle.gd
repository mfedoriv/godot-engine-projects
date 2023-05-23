extends Area2D

const SPEED = 200

func _physics_process(delta):
	position.x -= SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
