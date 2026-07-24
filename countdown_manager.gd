class_name CountdownManager
extends Node2D

@onready var countdown_timer: CountdownTimer = %CountdownTimer


func add_time(accuracy: float = 1) -> void:
    var time_gained: int = int(10 * accuracy * accuracy) #Accuracy exponentially weighted
    countdown_timer.time_left += time_gained
