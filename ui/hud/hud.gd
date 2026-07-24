extends Control

class_name HUD

signal submit_drawing
signal clear_drawing
signal select_tool(tool: PlayerDrawing.Tool)
signal select_color(color: Color)

@onready var score_counter: ScoreCounter = %ScoreCounter
@onready var submit_button: Button = %SubmitButton
@onready var clear_button: Button = %ClearButton
@onready var tool_select: ToolSelect = %ToolSelect
@onready var color_select: ColorSelect = %ColorSelect

func _ready() -> void:
    submit_button.pressed.connect(_on_submit_button_pressed)
    clear_button.pressed.connect(_on_clear_button_pressed)
    tool_select.tool_button_pressed.connect(_on_tool_button_pressed)
    color_select.select_color.connect(_on_select_color)

func select_color_index(index: int) -> void:
    color_select.select_color_index(index)

func _on_tool_button_pressed(tool: PlayerDrawing.Tool) -> void:
    select_tool.emit(tool)

func _on_submit_button_pressed() -> void:
    submit_drawing.emit()

func _on_clear_button_pressed() -> void:
    clear_drawing.emit()

func _on_select_color(color: Color) -> void:
    select_color.emit(color)

    
