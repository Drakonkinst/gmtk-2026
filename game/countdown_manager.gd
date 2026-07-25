class_name CountdownManager
extends Node2D

@onready var countdown_timer: CountdownTimer = %CountdownTimer

func get_seconds_left() -> int:
    return int(countdown_timer.time_left)

func spend_seconds(seconds: int) -> void:
    countdown_timer.time_left = max(0, countdown_timer.time_left - seconds)

func add_time(accuracy: float = 1) -> void:
    var time_gained: int = 0
    
    if accuracy >= 0.2:
        time_gained = int(10 * accuracy)
    
    countdown_timer.time_left += time_gained
