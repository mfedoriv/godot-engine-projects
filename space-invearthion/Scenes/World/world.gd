extends Node2D

@onready var sun: AnimatedSprite2D = $Background/Sun

@onready var earth_collision_polygon_2d: CollisionPolygon2D = $StaticBody2D/EarthCollisionPolygon2D



# Called when the node enters the scene tree for the first time.
func _ready():
    sun.play("move")
    
    var viewport_size = get_tree().root.content_scale_size
    
    print(viewport_size)
    draw_earth_collision_polygon(generate_polygon_coordinates(viewport_size.y / 2 - viewport_size.y * 0.01, 50, viewport_size))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
    

func generate_polygon_coordinates(radius: float, num_edges: int, viewport_size: Vector2 = Vector2(0, 0)) -> PackedVector2Array:
    var coordinates = PackedVector2Array()
    var angle_increment = 360.0 / num_edges
    var center = viewport_size / 2
    
    # Draw first half of frame
    coordinates.append(Vector2(0, viewport_size.y))
    coordinates.append(Vector2(viewport_size.x, viewport_size.y))
    coordinates.append(Vector2(viewport_size.x, center.y + radius * sin(0)))
    
    # Draw Circle
    for i in range(num_edges + 1):
        var angle_rad = deg_to_rad(i * angle_increment)
        var x = center.x + radius * cos(angle_rad)
        var y = center.y + radius * sin(angle_rad)
        coordinates.append(Vector2(x, y))
    
    # Draw second half of frame   
    coordinates.append(Vector2(viewport_size.x, coordinates[-1].y))
    coordinates.append(Vector2(viewport_size.x, 0))
    coordinates.append(Vector2(0, 0))
    
    return coordinates


func draw_earth_collision_polygon(coordinates: PackedVector2Array):
    earth_collision_polygon_2d.set_polygon(coordinates)
    
