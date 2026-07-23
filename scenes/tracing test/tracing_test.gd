extends Node2D

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("draw"):
        var new_line = TraceLine.new()
        add_child(new_line)
