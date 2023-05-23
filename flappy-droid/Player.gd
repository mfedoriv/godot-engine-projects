extends CharacterBody2D

signal hit

const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dead = false

func _physics_process(delta):
	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and not dead:
		velocity.y = JUMP_VELOCITY
	$AnimatedSprite2D.play("forward")
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("Collided with ", collision.get_collider().name)
		dead = true
		$AnimatedSprite2D.animation = "death" # Won't change!
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
