extends Node

class_name ScoreManager

signal update_score(score: int)

var score := 0

func add_score(value: int) -> void:
    set_score(score + value)

func set_score(value: int) -> void:
    score = value
    update_score.emit(score)
