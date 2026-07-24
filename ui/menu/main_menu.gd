extends Node

class_name MainMenu

signal start_game

func _ready() -> void:
    get_tree().paused = false
    Global.audio.start_bgm()
    # Show menus and connect buttons
    %StartButton.pressed.connect(_on_startbutton_pressed)
    
func _on_startbutton_pressed():
    start_game.emit()
