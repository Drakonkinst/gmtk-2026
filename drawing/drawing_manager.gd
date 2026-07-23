extends Node

class_name DrawingManager

@onready var image_loader: ImageLoader = %ImageLoader

@export var drawing_sprite: Sprite2D

var current_drawing_index: int = -1

func set_next_drawing() -> void:
    current_drawing_index = image_loader.pick_next_drawing_index(current_drawing_index)
    if current_drawing_index < 0:
        push_warning("WARN: Invalid drawing index ", current_drawing_index)
    var drawing_info := get_drawing_info()
    print("Selected next drawing: ", drawing_info.id)
    drawing_sprite.texture = drawing_info.image

func get_drawing_info() -> Drawing:
    return image_loader.get_drawing_info(current_drawing_index)

func get_image_data() -> PackedInt64Array:
    return image_loader.get_image_data(current_drawing_index)
    
