extends Control

class_name ScoreCounter

@onready var score_value: RichTextLabel = %ScoreValue
var last_displayed_score := 0

func _ready() -> void:
	Global.game.update_score.connect(_on_update_score)

func _on_update_score(score: int) -> void:
	score_value.text = str(score)
	# TODO: Find the delta between score and last displayed score to show UI effects
	last_displayed_score = score
	
