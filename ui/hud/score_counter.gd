extends Control

class_name ScoreCounter

const SCORE_DISPLAY_MULTIPLIER := 10
const CHANGE_PER_SECOND := 1500

@onready var score_value: RichTextLabel = %ScoreValue
@onready var score_label: RichTextLabel = %ScoreLabel
var last_displayed_score := 0
var target_score := 0

func _ready() -> void:
    Global.game.update_score.connect(_on_update_score)

func _process(delta: float) -> void:
    if last_displayed_score < target_score:
        last_displayed_score = min(last_displayed_score + CHANGE_PER_SECOND * delta, target_score)
    if last_displayed_score > target_score:
        last_displayed_score = max(last_displayed_score - CHANGE_PER_SECOND * delta, target_score)
    score_value.text = str(last_displayed_score)
    
func set_multiplier(multiplier: float) -> void:
    score_label.text = "Score (" + str(int(multiplier)) + "x): "

func _on_update_score(score: int) -> void:
    print("Score updated ", score)
    target_score = int(score) * SCORE_DISPLAY_MULTIPLIER
    # TODO: Find the delta between score and target_score to show UI effects
    
