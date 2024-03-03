extends RigidBody2D

# Экспортируемые переменные
@export var collision_threshold : float = 500.0
@export var rock_particles: PackedScene = preload("res://Scenes/Objects/rock_particles.tscn")

func _on_body_entered(body: Node) -> void:
    #print('COLISION!')
    # Проверяем скорость столкновения
    if body.is_in_group("CanDestructObjects"):  # Проверка на принадлежность к группе
        var relative_velocity = get_linear_velocity()

        if relative_velocity.length() > collision_threshold:
            spawn_bounce_particles(self.position, -relative_velocity)
            print('BUMP!')
            print('Velocity: ', relative_velocity.length())
            print('Trashhold: ', collision_threshold)
            # Удаляем текущий объект Node2D (компонент)
            queue_free()


func spawn_bounce_particles(pos: Vector2, normal: Vector2) -> void:
    var instance: GPUParticles2D = rock_particles.instantiate()
    get_tree().current_scene.add_child(instance)
    instance.global_position = pos
    instance.scale = Vector2(0.5, 0.5)
    instance.rotation = normal.angle()
