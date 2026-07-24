extends Node

class_name UpgradeManager

@export var unlocked_drawing_sets: Array[Drawing.DrawingSet] = [Drawing.DrawingSet.SIMPLE]
@export var unlocked_eraser := false

func is_drawing_set_unlocked(drawingSet: Drawing.DrawingSet) -> bool:
    return unlocked_drawing_sets.has(drawingSet)
