extends Area2D
class_name HurtBox

func _init():
	collision_layer = 2 + 8
	collision_mask = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
