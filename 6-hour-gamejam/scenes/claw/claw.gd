extends StaticBody2D

@onready var claw_left: StaticBody2D = $ClawLeft
@onready var claw_right: StaticBody2D = $ClawRight

@onready var animation_player = $AnimationPlayer

var is_open = true

var tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("claw"):
		if is_open:
			close_claw(0.5)
			is_open = false
		else:
			open_claw(0.5)
			is_open = true

func open_claw(time: float):
	tween = create_tween()
	tween.tween_property(claw_left, "rotation_degrees", 15, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(claw_right, "rotation_degrees", -15, time).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	

func close_claw(time: float):
	tween = create_tween()
	tween.tween_property(claw_left, "rotation_degrees", -15, time).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(claw_right, "rotation_degrees", 15, time).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished


