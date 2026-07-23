extends Resource

class_name Drawing

const WIDTH := 64
const HEIGHT := 32

enum DrawingSet {
    SIMPLE
}

@export var id: String
@export var image: Texture2D
@export var drawing_set: DrawingSet