class_name CountdownManager
extends Node2D

signal game_lose

const TIME_PER_DRAWING := 15
const ACCURACY_THRESHOLD := 0.2
const MAX_TIME := 30

@onready var countdown_timer: CountdownTimer = %CountdownTimer
@onready var timer: Timer = $Timer

var time_left: int = TIME_PER_DRAWING
var timer_initialized := false

func get_seconds_left() -> int:
    return time_left

func add_time(accuracy: float = 1) -> void:
    var time_gained: int = 0
    if accuracy >= ACCURACY_THRESHOLD:
        time_gained = int(TIME_PER_DRAWING * accuracy)
    change_time_big(time_gained)

func change_time_big(delta_time: int) -> void:
    set_time(time_left + delta_time, true)

func set_time(time: int, big_change: bool) -> void:
    var prev_time := time_left
    time_left = min(time, MAX_TIME)
    countdown_timer.update_displayed_time(time_left)
    if time_left < 0:
        time_left = 0
        timer.stop()
        game_lose.emit()
        AudioManager.stop_tick_tock_sfx()
    var delta := time_left - prev_time
    if big_change:
        countdown_timer.change_time(delta)

func _ready() -> void:
    timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
    if not timer_initialized:
        set_time(time_left, false)
        timer_initialized = true

func _on_timer_timeout() -> void:
    set_time(time_left - 1, false)
