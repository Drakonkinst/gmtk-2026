extends Node2D

class_name Game

signal exit_game
signal restart_game

@onready var upgrade_manager: UpgradeManager = %UpgradeManager
@onready var drawing_manager: DrawingManager = %DrawingManager

func _ready() -> void:
	drawing_manager.set_next_drawing()
