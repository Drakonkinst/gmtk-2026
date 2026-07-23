extends Node2D

class_name Game

signal exit_game
signal restart_game
signal update_score(score: int)
signal submit_drawing

@onready var upgrade_manager: UpgradeManager = %UpgradeManager
@onready var score_manager: ScoreManager = %ScoreManager
@onready var drawing_manager: DrawingManager = %DrawingManager
@onready var hud: HUD = %HUD

func _ready() -> void:
    drawing_manager.set_next_drawing()
    
    # Register player inputs
    hud.submit_drawing.connect(_on_submit_drawing)
    
    # HUD should only listen to game signals, pass everything up
    score_manager.update_score.connect(_on_update_score)
    
func _on_submit_drawing() -> void:
    drawing_manager.set_next_drawing()
    score_manager.add_score(10)
    submit_drawing.emit()

func _on_update_score(score: int) -> void:
    update_score.emit(score)


