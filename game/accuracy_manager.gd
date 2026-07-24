class_name AccuracyManager
extends Node2D

@onready var accuracy_display: AccuracyDisplay = %AccuracyDisplay

func update_accuracy(accuracy: float) -> void:
    accuracy_display.accuracy_value.text = str(int(accuracy * 100)) + "%"
