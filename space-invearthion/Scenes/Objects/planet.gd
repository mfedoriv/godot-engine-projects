extends Node2D

# Параметры движения вокруг точки
@onready var viewport_size = get_tree().root.content_scale_size
@onready var center_position = Vector2(viewport_size / 2) # Задайте центральную точку вокруг которой будет двигаться объект
var radius : float = 100.0 # Задайте радиус движения
var angular_speed : float = 0.5 # Задайте угловую скорость

# Параметры вращения вокруг своей оси
var rotation_speed : float = 1.0 # Задайте скорость вращения

# Текущий угол для движения вокруг точки
var current_angle : float = 0.0

func _process(delta: float) -> void:
    # Обновляем угол для движения вокруг точки
    current_angle += angular_speed * delta
    print(position)
    # Вычисляем новую позицию объекта
    var new_x : float = center_position.x + radius * cos(current_angle)
    var new_y : float = center_position.y + radius * sin(current_angle)

    # Устанавливаем новую позицию объекта
    position.x = new_x
    position.y = new_y

    # Проворачиваем объект вокруг своей оси
    rotation *= rotation_speed * delta
