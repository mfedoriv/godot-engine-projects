extends Area2D

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var speed = 1000

func  _ready() -> void:
	visible_on_screen_notifier.screen_exited.connect(_on_screen_exited)
	body_entered.connect(_on_body_entered)

var velocity = Vector2.ZERO

func start(_transform):
	transform = _transform
	velocity = transform.x * speed
	
func _process(delta):
	position += velocity * delta

func _on_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("rocks"):
		body.explode()
		queue_free()
