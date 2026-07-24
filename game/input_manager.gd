extends Node

class_name InputManager

signal draw(draw_pos: Vector2i)

var drawing_enabled := true
var is_drawing := false
var erase_override := false

const DRAWING_OFFSET_X := 240
const DRAWING_OFFSET_Y := 180
const SCALE_FACTOR := 3

const NULL_DRAWING_POS := Vector2i(-1, -1)

func _process_drawing(delta: float):
    erase_override = Input.is_action_pressed("erase_override")
    if Input.is_action_pressed("draw"):
        var mouse_pos := get_viewport().get_mouse_position()
        var drawing_pos := _to_drawing_pos(mouse_pos)
        if drawing_pos != NULL_DRAWING_POS:
            draw.emit(drawing_pos)
            is_drawing = true

func _to_drawing_pos(screen_pos: Vector2) -> Vector2i:
    var drawing_pos_x: int = round((screen_pos.x - DRAWING_OFFSET_X) / SCALE_FACTOR)
    var drawing_pos_y: int = round((screen_pos.y - DRAWING_OFFSET_Y) / SCALE_FACTOR)
    if drawing_pos_x >= Drawing.WIDTH || drawing_pos_y >= Drawing.HEIGHT || drawing_pos_x < 0 || drawing_pos_y < 0:
        return NULL_DRAWING_POS
    return Vector2i(drawing_pos_x, drawing_pos_y)
    
func _reset_drawing_state() -> void:
    is_drawing = false
    erase_override = false

func _process(delta: float) -> void:
    _reset_drawing_state()
    if drawing_enabled:
        _process_drawing(delta)

        
    