extends Node

class_name ScoreManager

const BASE_SCORE := 100
const AVG_DRAWING_TIME := 15
const SPEED_WEIGHT := 2.0

signal update_score(score: int)

var score := 0

func calculate_score(accuracy: float, time_spent: float, drawing_info: Drawing) -> int:
    var remaining_time: int = max(0, AVG_DRAWING_TIME - time_spent)
    var base_score := accuracy * BASE_SCORE
    var speed_bonus := accuracy * remaining_time * SPEED_WEIGHT
    var final_score := (base_score + speed_bonus) * Global.game.upgrade_manager.score_multiplier
    return int(final_score)

func add_score(value: int) -> void:
    print("Adding score ", value, " to ", score)
    set_score(score + value)

func set_score(value: int) -> void:
    score = value
    update_score.emit(score)
    Global.score = score
