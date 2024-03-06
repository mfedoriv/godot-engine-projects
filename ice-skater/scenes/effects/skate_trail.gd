extends Line2D

@export_category('Trail')
@export var length := 10
@export var offset := Vector2.ZERO
@export var is_right: bool

@onready var parent: Node2D = get_parent()
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var can_draw: bool = true

signal screen_exited_line

func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(delete_line)
	is_right = parent.is_right
	offset = position
	offset.x += 25 if is_right else -25
	width = 2

func draw_point():
	if !can_draw:
		return
	if is_right != parent.is_right:
		can_draw = false
		return
	var point: Vector2 = parent.global_position + offset
	add_point(point, 0)

func _on_screen_exited() -> void:
	screen_exited_line.emit()

func delete_line() -> void:
	queue_free()
