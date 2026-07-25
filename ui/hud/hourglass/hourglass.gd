extends Control

class_name Hourglass

const OFFSET := 0.54

@onready var sand_progress: TextureProgressBar = %SandProgress
@onready var falling_sand: Control = %FallingSand

func _process(delta: float) -> void:
    var time_left := Global.game.countdown_manager.time_left
    var max_time := Global.game.countdown_manager.MAX_TIME
    var percentage: float = clamp(time_left * 1.0 / max_time, 0.0, 1.0)
    var display_percentage := OFFSET + percentage * (1.0 - OFFSET)
    sand_progress.value = display_percentage
