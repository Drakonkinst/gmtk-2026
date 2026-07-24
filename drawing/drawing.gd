extends Resource

class_name Drawing

const WIDTH := 160
const HEIGHT := 120
static var EMPTY_COLOR_INT := Color(0, 0, 0, 0).to_argb64()

enum DrawingSet {
    SIMPLE
}

@export var id: String
@export var image: Texture2D
@export var drawing_set: DrawingSet
