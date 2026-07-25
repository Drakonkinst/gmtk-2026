class_name CountdownManager
extends Node2D

signal game_lose

const TIME_PER_DRAWING := 15
const ACCURACY_THRESHOLD := 0.2

@onready var countdown_timer: CountdownTimer = %CountdownTimer
@onready var timer: Timer = $Timer

var time_left: int = TIME_PER_DRAWING

func get_seconds_left() -> int:
    return time_left

func spend_seconds(time_lost: int) -> void:
    countdown_timer.change_time(-time_lost)
    set_time(time_left - time_lost)

func add_time(accuracy: float = 1) -> void:
    var time_gained: int = 0
    
    if accuracy >= ACCURACY_THRESHOLD:
        time_gained = int(TIME_PER_DRAWING * accuracy)
    
    countdown_timer.change_time(time_gained)
    set_time(time_left + time_gained)

func set_time(time: int) -> void:
    time_left = time
    countdown_timer.update_displayed_time(time_left)
    if time_left < 0:
        time_left = 0
        timer.stop()
        game_lose.emit()
        AudioManager.stop_tick_tock_sfx()

func _ready() -> void:
    timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
    set_time(time_left - 1)
