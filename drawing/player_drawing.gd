extends Node

class_name PlayerDrawing

enum BrushMode { RADIAL }

var TRANSPARENT_COLOR = Color(0, 0, 0, 0)

@export var player_image_display: Sprite2D
var player_image_texture: Texture2D
var needs_update := false
var player_image: Image
var brush_size := 2
var brush_mode: BrushMode = BrushMode.RADIAL
var brush_color := Color(0, 0, 0, 1)

func _ready() -> void:
    player_image = Image.create_empty(Drawing.WIDTH, Drawing.HEIGHT, false, Image.FORMAT_RGBA8)
    player_image_texture = ImageTexture.create_from_image(player_image)
    player_image_display.texture = player_image_texture
    reset_image()

func _process(delta: float) -> void:
    if needs_update:
        update_image()

func on_draw(draw_pos: Vector2i) -> void:
    if Global.game.input_manager.erase_override:
        draw_pencil(draw_pos)
    else:
        draw_pencil(draw_pos)

func draw_pencil(center_pos: Vector2i) -> void:
    for brush_offset_x in range(-brush_size, brush_size + 1):
        for brush_offset_y in range(-brush_size, brush_size + 1):
            var x := center_pos.x + brush_offset_x
            var y := center_pos.y + brush_offset_y
            if brush_mode == BrushMode.RADIAL and not _is_in_radial_distance(center_pos, x, y, brush_size):
                continue
            player_image.set_pixel(x, y, brush_color)
            needs_update = true

func _is_in_radial_distance(center_pos: Vector2i, x: int, y: int, radius: int) -> bool:
    var delta_x := center_pos.x - x
    var delta_y := center_pos.y - y
    # Use Manhattan distance instead of Euclidean for a tapered edge
#    return abs(delta_x) + abs(delta_y) <= radius
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
