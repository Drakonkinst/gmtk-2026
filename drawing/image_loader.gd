extends Node

class_name ImageLoader

@export var drawings: Array[Drawing]

# Array of the same length as drawings to hold image data
var image_data_array: Array[PackedInt64Array]

func _ready() -> void:
    for drawing in drawings:
        var image: Image = drawing.image.get_image()
        var image_data: PackedInt64Array = []
        # TODO: Probably check that all images are the expected width and height
        image_data.resize(image.get_height() * image.get_width())
        image_data.fill(-1)
        for y in image.get_height():
            for x in image.get_width():
                var color = image.get_pixel(x, y)
                var color_value = color.to_argb64()
                if color_value != -1:
                    image_data.set(y * image.get_width() + x, color_value)
        image_data_array.push_back(image_data)
