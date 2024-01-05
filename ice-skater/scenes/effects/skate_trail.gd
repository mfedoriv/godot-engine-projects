extends Line2D

@export_category('Trail')
@export var length : = 10
@export var offset : = Vector2.ZERO
@export var is_right: bool

@onready var parent : Node2D = get_parent()
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var can_draw: bool = true

signal screen_exited_line

func _ready() -> void:
	#visible_on_screen_notifier_2d.screen_exited.connect(delete_line)
	print(self)
	#is_right = parent.is_right
	#offset = position
	#offset.x += 25 if is_right else -25
	#top_level = true
	width = 2

func _process(_delta: float) -> void:
	global_position = Vector2.ZERO
	draw_point()
		

func draw_point():
	#if !can_draw:
		#return
	#if is_right != parent.is_right:
		#can_draw = false
		#return
	#print('Is Right: ', is_right, ' Parent Is Right: ', parent.is_right)
	# Перемещаем линию в соответствии с позицией родителя
	var point : = global_position + offset
	add_point(point, 0)


#func delete_line():
	#print("Deleting line")
	#queue_free()


func _on_screen_exited() -> void:
	screen_exited_line.emit()
