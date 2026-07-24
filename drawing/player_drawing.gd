extends Node

class_name PlayerDrawing

enum BrushMode { RADIAL }
enum Tool { BRUSH, ERASER }

var TRANSPARENT_COLOR = Color(0, 0, 0, 0)
const AVOID_CORNER := 12

@export var player_image_display: Sprite2D
var player_image_texture: Texture2D
var needs_update := false
var player_image: Image
var brush_size := 2
var brush_mode: BrushMode = BrushMode.RADIAL
var brush_color := Color(0, 0, 0, 1)
var selected_tool := Tool.BRUSH

func _ready() -> void:
    player_image = Image.create_empty(Drawing.WIDTH, Drawing.HEIGHT, false, Image.FORMAT_RGBA8)
    player_image_texture = ImageTexture.create_from_image(player_image)
    player_image_display.texture = player_image_texture
    reset_image()

func _process(delta: float) -> void:
    if needs_update:
        update_image()

func is_inside_canvas(drawing_pos_x: int, drawing_pos_y) -> bool:
    if drawing_pos_x >= Drawing.WIDTH or drawing_pos_y >= Drawing.HEIGHT or drawing_pos_x < 0 or drawing_pos_y < 0:
        return false
    # Don't let them draw in the corners
    if drawing_pos_x + drawing_pos_y < AVOID_CORNER:
        return false
    if (Drawing.WIDTH - 1 - drawing_pos_x) + drawing_pos_y < AVOID_CORNER:
        return false
    if drawing_pos_x + (Drawing.HEIGHT - 1 - drawing_pos_y) < AVOID_CORNER:
        return false
    if (Drawing.WIDTH - 1 - drawing_pos_x) + (Drawing.HEIGHT - 1 - drawing_pos_y) < AVOID_CORNER:
        return false
    return true

func set_selected_tool(tool: Tool) -> bool:
    if tool == Tool.ERASER and not Global.game.upgrade_manager.unlocked_eraser:
        return false
    selected_tool = tool
    return true

func set_brush_color(color: Color) -> bool:
    brush_color = color
    return true

func set_brush_size(size: int) -> bool:
    brush_size = size
    return true

func on_draw(draw_pos: Vector2i) -> void:
    if Global.game.input_manager.erase_override:
        erase(draw_pos)
    else:
        if selected_tool == Tool.BRUSH:
            draw_pencil(draw_pos)
        elif selected_tool == Tool.ERASER:
            erase(draw_pos)

func draw_at_point(center_pos: Vector2i, color: Color) -> void:
    for brush_offset_x in range(-brush_size, brush_size + 1):
        for brush_offset_y in range(-brush_size, brush_size + 1):
            var x := center_pos.x + brush_offset_x
            var y := center_pos.y + brush_offset_y
            if brush_mode == BrushMode.RADIAL and not _is_in_radial_distance(center_pos, x, y, brush_size):
                continue
            player_image.set_pixel(x, y, color)
            needs_update = true

func erase(center_pos: Vector2i) -> void:
   draw_at_point(center_pos, TRANSPARENT_COLOR)

func draw_pencil(center_pos: Vector2i) -> void:
    draw_at_point(center_pos, brush_color)

func _is_in_radial_distance(center_pos: Vector2i, x: int, y: int, radius: int) -> bool:
    var delta_x := center_pos.x - x
    var delta_y := center_pos.y - y
    var dist_sq := delta_x * delta_x + delta_y * delta_y
    return dist_sq <= radius * radius

func reset_image() -> void:
    player_image.fill(TRANSPARENT_COLOR)
    needs_update = true

func update_image() -> void:
    player_image_display.texture.update(player_image)
    needs_update = false

func pack_image() -> PackedInt64Array:
    var image_data: PackedInt64Array = []
    image_data.resize(Drawing.WIDTH * Drawing.HEIGHT)
    image_data.fill(Drawing.EMPTY_COLOR_INT)
    for y in player_image.get_height():
        for x in player_image.get_width():
            var color = player_image.get_pixel(x, y)
            var color_value = color.to_argb64()
            if color_value != Drawing.EMPTY_COLOR_INT:
                image_data.set(y * Drawing.WIDTH + x, color_value)
    return image_data
