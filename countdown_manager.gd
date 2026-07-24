class_name CountdownManager
extends Node2D

@onready var countdown_timer: CountdownTimer = %CountdownTimer

func add_time(value: int = 10) -> void:
    countdown_timer.time_left += value
