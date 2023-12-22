extends RigidBody2D

# Экспортируемые переменные
@export var destructible_piece_scene : PackedScene = preload("res://Scenes/Objects/medium_rock.tscn")
@export var collision_threshold : float = 400.0


func _on_body_entered(body: Node) -> void:
    print('COLISION!')
    
        # Проверяем скорость столкновения
    if body.is_in_group("CanDestructObjects"):  # Проверка на принадлежность к группе
        var relative_velocity = get_linear_velocity()

        print('Velocity: ', get_linear_velocity().length())
        print('Trashhold: ', collision_threshold)
        
        if relative_velocity.length() > collision_threshold:
            # Создаем несколько мелких частей и добавляем их в сцену
            for i in range(3):  # Пример: создаем 3 части
                var piece = destructible_piece_scene.instantiate()
                piece.position = self.position
                piece.linear_velocity = relative_velocity / 3 + Vector2(randf_range(5, 30), randf_range(5, 30))
                
                # Добавляем в сцену или в узел, который будет содержать все части
                get_parent().add_child(piece)

            # Удаляем текущий объект Node2D (компонент)
            queue_free()
