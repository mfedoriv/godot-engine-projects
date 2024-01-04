extends Line2D

@export_category('Trail')
@export var length : = 10

@onready var parent : Node2D = get_parent()
var offset : = Vector2.ZERO

func _ready() -> void:
	offset = position
	top_level = true
	width = 2

func _process(_delta: float) -> void:
	global_position = Vector2.ZERO

	# Перемещаем линию в соответствии с позицией родителя
	var point : = parent.global_position + offset
	add_point(point, 0)

	# Проверяем, все ли точки находятся за пределами видимой области экрана
	var all_points_outside = true
	for i in range(get_point_count()):
		var point_global_position = to_global(get_point_position(i))
		if get_viewport().get_visible_rect().has_point(point_global_position):
			# Если хотя бы одна точка внутри видимой области, выходим из цикла
			all_points_outside = false
			break

	if all_points_outside:
		# Если все точки за пределами видимой области экрана, удаляем линию
		queue_free()
