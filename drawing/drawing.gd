extends Resource

class_name Drawing

enum DrawingSet {
    SIMPLE
}

@export var id: String
@export var image: Texture2D
@export var drawing_set: DrawingSet