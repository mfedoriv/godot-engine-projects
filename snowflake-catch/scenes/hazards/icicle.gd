extends Node2D

var falling_speed = 1000
var can_fall = false
@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pre_fall()

func pre_fall():
	animation_player.play("pre_fall")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_fall:
		position.y += falling_speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_animation_player_animation_finished(anim_name):
	can_fall = true
