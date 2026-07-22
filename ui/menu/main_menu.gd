extends Node

class_name MainMenu

signal start_game

func _ready() -> void:
    get_tree().paused = false
    # Show menus and connect buttons
