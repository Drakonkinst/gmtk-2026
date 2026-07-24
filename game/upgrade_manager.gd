extends Node

class_name UpgradeManager

@export var unlocked_drawing_sets: Array[Drawing.DrawingSet] = [Drawing.DrawingSet.SIMPLE]
@export var unlocked_tools: Dictionary

func _ready() -> void:
    unlocked_tools[PlayerDrawing.Tool.BRUSH] = true
    unlocked_tools[PlayerDrawing.Tool.ERASER] = true

func is_drawing_set_unlocked(drawingSet: Drawing.DrawingSet) -> bool:
    return unlocked_drawing_sets.has(drawingSet)
