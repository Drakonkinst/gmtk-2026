extends Control

class_name ScoreCounter

const SCORE_DISPLAY_MULTIPLIER := 10

@onready var score_value: RichTextLabel = %ScoreValue
@onready var score_label: RichTextLabel = %ScoreLabel
var last_displayed_score := 0

func _ready() -> void:
    Global.game.update_score.connect(_on_update_score)

func set_multiplier(multiplier: float) -> void:
    score_label.text = "Score (" + str(int(multiplier)) + "x): "

func _on_update_score(score: int) -> void:
    print("Score updated ", score)
    var display_score := int(score) * SCORE_DISPLAY_MULTIPLIER
    score_value.text = str(display_score)
    # TODO: Find the delta between score and last displayed score to show UI effects
    last_displayed_score = display_score
    
