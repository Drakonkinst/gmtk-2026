class_name TraceLine
extends Line2D

var drawing: bool = true
var saved_points: Array[Vector2]
#var image_data: PackedInt64Array = []
#image_data.resize(Drawing.WIDTH * Drawing.HEIGHT)
#image_data.fill(-1)

func _input(event: InputEvent) -> void:
    if Input.is_action_pressed("draw"):
        if drawing == false: return
        
        if event is InputEventMouseMotion:
            var new_pos: Vector2 = event.position
            var min_draw_dist: float = 2
            if get_point_count() == 0:
                add_point(new_pos)
            elif new_pos.distance_to(get_point_position(get_point_count() - 1)) > min_draw_dist:
                add_point(new_pos)
        
        default_color = Color.WEB_GREEN
    
    if event.is_action_released("draw"):
        drawing = false
    
    if Input.is_action_pressed("erase"):
        var min_erase_distance: float = 10
        var mouse_pos: Vector2
        if event is InputEventMouseMotion:
            mouse_pos = event.position
        
        var i: int = 0
        for point in points:
            if mouse_pos.distance_to(point) < min_erase_distance:
                for j in (points.size() - i):
                    saved_points.append(get_point_position(i))
                    remove_point(i)
                split_line()
                
                return
            i += 1

func split_line() -> void:
    var new_line := TraceLine.new()
    new_line.default_color = Color.WEB_GREEN
    new_line.drawing = false
    
    for point in saved_points:
        new_line.add_point(point)
    saved_points.clear()
    
    add_sibling(new_line)

func _process(_delta: float) -> void:
    if !drawing:
        if get_point_count() <= 1:
            queue_free()
