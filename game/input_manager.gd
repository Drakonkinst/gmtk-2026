extends Node

class_name InputManager

signal draw(draw_pos: Vector2i)
signal select_tool(tool: PlayerDrawing.Tool)
signal submit_drawing

const DRAWING_OFFSET_X := 240
const DRAWING_OFFSET_Y := 180
const SCALE_FACTOR := 3
const NULL_DRAWING_POS := Vector2i(-1, -1)

# Drawing State
var drawing_enabled := true
var is_drawing := false
var erase_override := false

# Input Tracking
var last_drawing_pos := NULL_DRAWING_POS

func _draw_if_in_frame(draw_pos: Vector2i):
    if Global.game.player_drawing.is_inside_canvas(draw_pos.x, draw_pos.y):
        draw.emit(draw_pos)

func _process_drawing(delta: float):
    erase_override = Input.is_action_pressed("erase_override") and Global.game.upgrade_manager.unlocked_tools[PlayerDrawing.Tool.ERASER]
    if Input.is_action_pressed("draw") or erase_override:
        var mouse_pos := get_viewport().get_mouse_position()
        var drawing_pos := _to_drawing_pos(mouse_pos)
        
        if last_drawing_pos == NULL_DRAWING_POS:
            _draw_if_in_frame(drawing_pos)
        else:
            _interpolate_line(last_drawing_pos, drawing_pos) 
           
        is_drawing = true
        last_drawing_pos = drawing_pos
    else:
        last_drawing_pos = NULL_DRAWING_POS
    
    if Input.is_action_just_pressed("select_brush"):
        select_tool.emit(PlayerDrawing.Tool.BRUSH)
    if Input.is_action_just_pressed("select_eraser"):
        select_tool.emit(PlayerDrawing.Tool.ERASER)
    if Input.is_action_just_pressed("submit"):
        submit_drawing.emit()
    
# Bresenham's line algorithm        
func _interpolate_line(p0: Vector2i, p1: Vector2i) -> void:
    var delta_x: int = abs(p1.x - p0.x)
    var delta_y: int = abs(p1.y - p0.y)
    var step_x := 1 if p0.x < p1.x else -1
    var step_y := 1 if p0.y < p1.y else -1
    var error := delta_x - delta_y
    
    while true:
        if p0 != last_drawing_pos:
            _draw_if_in_frame(p0)
        if p0.x == p1.x and p0.y == p1.y:
            break
        var double_error := 2 * error
        if double_error > -delta_y:
            error -= delta_y
            p0.x += step_x
        if double_error < delta_x:
            error += delta_x
            p0.y += step_y

func _to_drawing_pos(screen_pos: Vector2) -> Vector2i:
    var drawing_pos_x: int = round((screen_pos.x - DRAWING_OFFSET_X) / SCALE_FACTOR)
    var drawing_pos_y: int = round((screen_pos.y - DRAWING_OFFSET_Y) / SCALE_FACTOR)
    return Vector2i(drawing_pos_x, drawing_pos_y)

func _reset_drawing_state() -> void:
    is_drawing = false
    erase_override = false

func _process(delta: float) -> void:
    _reset_drawing_state()
    if drawing_enabled:
        _process_drawing(delta)

        
    
