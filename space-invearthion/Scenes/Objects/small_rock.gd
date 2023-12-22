extends RigidBody2D

# Экспортируемые переменные
@export var collision_threshold : float = 200.0


func _on_body_entered(body: Node) -> void:
    print('COLISION!')
    # Проверяем скорость столкновения
    if body.is_in_group("CanDestructObjects"):  # Проверка на принадлежность к группе
        var relative_velocity = get_linear_velocity().length()

        print('Velocity: ', get_linear_velocity().length())
        print('Trashhold: ', collision_threshold)
        
        if relative_velocity > collision_threshold:
            # Удаляем текущий объект Node2D (компонент)
            queue_free()
