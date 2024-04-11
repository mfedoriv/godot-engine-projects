extends RigidBody2D

@onready var claw_left_sprite: Sprite2D = $ClawLeftSprite
@onready var claw_right_sprite: Sprite2D = $ClawRightSprite
@onready var claw_left_collision: CollisionPolygon2D = $ClawLeftCollision
@onready var claw_right_collision: CollisionPolygon2D = $ClawRightCollision


var is_open = true

var tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("claw"):
		if is_open:
			close_claw(12, 0.5)
			is_open = false
		else:
			open_claw(20, 0.5)
			is_open = true

func open_claw(degrees: int, time: float):
	tween = create_tween()
	tween.tween_property(claw_left_sprite, "rotation_degrees", degrees, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(claw_left_collision, "rotation_degrees", degrees, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(claw_right_sprite, "rotation_degrees", -degrees, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(claw_right_collision, "rotation_degrees", -degrees, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	

func close_claw(degrees: int, time: float):
	tween = create_tween()
	tween.tween_property(claw_left_sprite, "rotation_degrees", -degrees, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(claw_left_collision, "rotation_degrees", -degrees, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(claw_right_sprite, "rotation_degrees", degrees, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(claw_right_collision, "rotation_degrees", degrees, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished


