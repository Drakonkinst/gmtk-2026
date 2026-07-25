class_name CountdownManager
extends Node2D

@onready var countdown_timer: CountdownTimer = %CountdownTimer


func add_time(accuracy: float = 1) -> void:
    var time_gained: int
    
    if accuracy <= 0.2:
        time_gained = 0
    else:
        time_gained = int(10 * accuracy)
    
    countdown_timer.time_left += time_gained
