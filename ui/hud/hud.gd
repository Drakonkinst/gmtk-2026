extends Control

class_name HUD

signal submit_drawing
signal clear_drawing
signal select_tool

@onready var score_counter: ScoreCounter = %ScoreCounter
@onready var submit_button: Button = %SubmitButton
@onready var clear_button: Button = %ClearButton
@onready var tool_select: ToolSelect = %ToolSelect

func _ready() -> void:
    submit_button.pressed.connect(_on_submit_button_pressed)
    clear_button.pressed.connect(_on_clear_button_pressed)
    tool_select.tool_button_pressed.connect(_on_tool_button_pressed)

func _on_tool_button_pressed(tool: PlayerDrawing.Tool) -> void:
    select_tool.emit(tool)

func _on_submit_button_pressed() -> void:
    submit_drawing.emit()

func _on_clear_button_pressed() -> void:
    clear_drawing.emit()
    
