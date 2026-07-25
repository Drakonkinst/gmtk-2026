extends Node

class_name ImageLoader

@export var drawings: Array[Drawing]

var _max_attempts := 3

# Array of the same length as drawings to hold image data
var image_data_array: Array[PackedInt64Array]
var is_first_drawing := true

func _ready() -> void:
    for drawing in drawings:
        print("Loading image ", drawing.id)
        var image: Image = drawing.image.get_image()
        var image_data: PackedInt64Array = []
        if image.get_width() != Drawing.WIDTH || image.get_height() != Drawing.HEIGHT:
            push_warning("Invalid dimensions for ", drawing.id, ": ", image.get_width(), " by ", image.get_height())
        image_data.resize(image.get_height() * image.get_width())
        image_data.fill(Drawing.EMPTY_COLOR_INT)
        for y in image.get_height():
            for x in image.get_width():
                var color := image.get_pixel(x, y)
                if color.a == 1:
                    var color_value := color.to_argb64()
                    image_data.set(y * image.get_width() + x, color_value)
        image_data_array.push_back(image_data)
        print("Finished loading image ", drawing.id)

func get_drawing_info(index: int) -> Drawing:
    return drawings[index]

func get_image_data(index: int) -> PackedInt64Array:
    return image_data_array[index]

# Best effort to pick a different drawing
func pick_next_drawing_index(prev_index: int) -> int:
    var valid_drawing_indexes := _collect_valid_drawing_indexes().filter(func (index):
        if index == prev_index:
            return false
        if is_first_drawing and drawings.get(index).id == "Loss":
            return false
        return true
    )
    if is_first_drawing:
        is_first_drawing = false
    
    var next_index := prev_index
    if len(valid_drawing_indexes) <= 0:
        push_warning("WARN: No valid drawing indexes")
        return prev_index
    
    var valid_drawing_weights: Array[float] = []
    var total_weight := 0.0
    for index in valid_drawing_indexes:
        var drawing: Drawing = drawings.get(index)
        valid_drawing_weights.push_back(drawing.weight) 
        total_weight += drawing.weight

    var target_weight := randf_range(0.0, total_weight)
    var track_weight := 0.0
    var track_index := 0
    while track_index < len(valid_drawing_indexes):
        track_weight += valid_drawing_weights[track_index]
        if track_weight >= target_weight:
            next_index = valid_drawing_indexes[track_index]
            break
        track_index += 1
    print("Picked ", next_index)
    return next_index
    

func _collect_valid_drawing_indexes() -> Array[int]:
    var result: Array[int] = []
    for i in range(len(drawings)):
        var drawing: Drawing = drawings.get(i)
        if _is_valid_drawing(drawing):
            result.push_back(i)
    return result

func _is_valid_drawing(drawing: Drawing) -> bool:
    return Global.game.upgrade_manager.is_drawing_set_unlocked(drawing.drawing_set)
