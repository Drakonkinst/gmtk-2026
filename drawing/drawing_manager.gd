extends Node

class_name DrawingManager

@onready var image_loader: ImageLoader = %ImageLoader

# The sprite the player needs to match
@export var drawing_sprite: Sprite2D

const K_FACTOR := 2.0 # Lower = requires more precision, higher = more forgiving
const INCORRECT_COLOR_PENALTY := 0.4 # Deducts a percentage if the wrong color is used
static var OFFSETS := [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]

class GoalLookup:
    var distance: float
    var target_color_int: int

var current_drawing_index: int = -1
var goal_map: Dictionary

# Faster O(N) approach
func _precompute_goal_maps_2(goal_array: PackedInt64Array) -> Dictionary:
    var lookup_map: Dictionary = {}
    for i in range(Drawing.WIDTH * Drawing.HEIGHT):
        var default_data := GoalLookup.new()
        default_data.distance = INF
        default_data.target_color_int = Drawing.EMPTY_COLOR_INT
        lookup_map[i] = default_data
    
    var queue: Array[Vector2i] = []
    for i in range(goal_array.size()):
        var color_int = goal_array[i]
        if color_int != Drawing.EMPTY_COLOR_INT:
             var goal_x := i % Drawing.WIDTH
             var goal_y := int(i * 1.0 / Drawing.WIDTH) # Getting around the silly syntax warnings
             var pos := Vector2i(goal_x, goal_y)
             var data: GoalLookup = lookup_map[i]
             data.distance = 0.0
             data.target_color_int = color_int
             queue.append(pos)
    
    if queue.is_empty():
        push_warning("Image has no drawn pixels")
        return lookup_map
    
    var head := 0
    while head < queue.size():
        var current_pos := queue[head]
        head += 1
        
        var current_index = current_pos.y * Drawing.WIDTH + current_pos.x
        var current_lookup: GoalLookup = lookup_map[current_index]
        
        for dir in OFFSETS:
            var next_pos = current_pos + dir
            if next_pos.x >= 0 and next_pos.x < Drawing.WIDTH and next_pos.y >= 0 and next_pos.y < Drawing.HEIGHT:
                var next_index: int = next_pos.y * Drawing.WIDTH + next_pos.x
                var next_lookup: GoalLookup = lookup_map[next_index]
                var new_dist = current_lookup.distance + 1.0
                if new_dist < next_lookup.distance:
                    next_lookup.distance = new_dist
                    next_lookup.target_color_int = current_lookup.target_color_int
                    queue.append(next_pos)
    
    return lookup_map

# Older O(N x M) approach
func _precompute_goal_maps(goal_array: PackedInt64Array) -> Dictionary:
    var lookup_map: Dictionary = {}
    
    # Find all valid drawn pixels in goal image
    var goal_pixels: Array = []
    for i in range(goal_array.size()):
        var color_int = goal_array[i]
        if color_int != Drawing.EMPTY_COLOR_INT:
            var goal_x := i % Drawing.WIDTH
            var goal_y := int(i * 1.0 / Drawing.WIDTH) # Getting around the silly syntax warnings
            goal_pixels.push_back({
                "pos": Vector2i(goal_x, goal_y),
                "color_int": color_int
            })
    
    # Generate closest-neighbor map for every coordinate
    for y in range(Drawing.HEIGHT):
        print("y=", y)
        for x in range(Drawing.WIDTH):
            var current_pos = Vector2i(x, y)
            var min_distance: float = INF
            var closest_color_int: int = Drawing.EMPTY_COLOR_INT
            
            for goal_pixel in goal_pixels:
                var dist = current_pos.distance_to(goal_pixel.pos)
                if dist < min_distance:
                    min_distance = dist
                    closest_color_int = goal_pixel.color_int
            
            if min_distance == INF:
                min_distance = 0.0
            
            var data := GoalLookup.new()
            data.distance = min_distance
            data.target_color_int = closest_color_int
            lookup_map[current_pos] = data
    return lookup_map

func calculate_accuracy(user_array: PackedInt64Array) -> float:
    var total_pixels_drawn := 0
    var cumulative_accuracy: float = 0.0
    
    for i in range(user_array.size()):
        var user_color_int = user_array[i]
        if user_color_int == Drawing.EMPTY_COLOR_INT:
            continue
        total_pixels_drawn += 1
        var user_x = i % Drawing.WIDTH
        var user_y = int(i * 1.0 / Drawing.WIDTH)
        var user_pos = Vector2i(user_x, user_y)
        
        var lookup: GoalLookup = goal_map[user_pos]
        # Geometric distance score (Exponential decay)
        var distance_accuracy = exp(-lookup.distance / K_FACTOR)
        
        # Fast integer color match
        var color_accuracy: float = 1.0
        if user_color_int != lookup.target_color_int:
            color_accuracy -= INCORRECT_COLOR_PENALTY
            
        var pixel_accuracy = max(0.0, distance_accuracy * color_accuracy)
        cumulative_accuracy += pixel_accuracy 
    
    if total_pixels_drawn == 0:
        return 0
    return cumulative_accuracy / total_pixels_drawn

func set_next_drawing() -> void:
    current_drawing_index = image_loader.pick_next_drawing_index(current_drawing_index)
    if current_drawing_index < 0:
        push_warning("WARN: Invalid drawing index ", current_drawing_index)
    var drawing_info := get_drawing_info()
    var image_data := get_image_data()
    print("Selected next drawing: ", drawing_info.id)
    drawing_sprite.texture = drawing_info.image
    print("Precomputing goal maps for ", drawing_info.id)
    goal_map = _precompute_goal_maps_2(image_data)
    print("Finished precomputing goal maps for ", drawing_info.id)
    
func get_drawing_info() -> Drawing:
    return image_loader.get_drawing_info(current_drawing_index)

func get_image_data() -> PackedInt64Array:
    return image_loader.get_image_data(current_drawing_index)
    
