extends Control

class_name HUD

signal submit_drawing

@onready var score_counter: ScoreCounter = %ScoreCounter
@onready var submit_button: Button = %SubmitButton

func _ready() -> void:
    submit_button.pressed.connect(_on_submit_button_pressed)

func _on_submit_button_pressed() -> void:
    submit_drawing.emit()
    