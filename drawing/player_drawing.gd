extends Node

class_name PlayerDrawing

@export var player_image_display: Sprite2D
var player_image: Image

func _ready() -> void:
    reset_image()

func reset_image() -> void:
    player_image = Image.new()
    player_image.resize(Drawing.WIDTH, Drawing.HEIGHT)
    update_image()
    
func update_image() -> void:
    player_image_display.texture = ImageTexture.create_from_image(player_image)

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