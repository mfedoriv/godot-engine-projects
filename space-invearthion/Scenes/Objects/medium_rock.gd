extends RigidBody2D

# Экспортируемые переменные
@export var destructible_piece_scene : PackedScene = preload("res://Scenes/Objects/small_rock.tscn")
@export var rock_particles: PackedScene = preload("res://Scenes/Objects/rock_particles.tscn")
@export var collision_threshold : float = 600.0


func _on_body_entered(body: Node) -> void:
    #print('COLISION!')
    
        # Проверяем скорость столкновения
    if body.is_in_group("CanDestructObjects"):  # Проверка на принадлежность к группе
        var relative_velocity = get_linear_velocity()

        if relative_velocity.length() > collision_threshold:
            print('BUMP!')
            print('Velocity: ', relative_velocity.length())
            print('Trashhold: ', collision_threshold)
            spawn_bounce_particles(self.position, -relative_velocity)
            # Создаем несколько мелких частей и добавляем их в сцену
            for i in range(3):  # Пример: создаем 3 части
                var piece = destructible_piece_scene.instantiate()
                piece.position = self.position
                piece.linear_velocity = relative_velocity / 3 + Vector2(randf_range(5, 30), randf_range(5, 30))
                # Добавляем в сцену или в узел, который будет содержать все части
                get_parent().add_child(piece)

            # Удаляем текущий объект Node2D (компонент)
            queue_free()


func spawn_bounce_particles(pos: Vector2, normal: Vector2) -> void:
    var instance: GPUParticles2D = rock_particles.instantiate()
    get_tree().current_scene.add_child(instance)
    instance.global_position = pos
    instance.scale = Vector2(1, 1)
    instance.rotation = normal.angle()
