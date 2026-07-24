extends Node2D

class_name Game

signal exit_game
signal restart_game
signal update_score(score: int)
signal submit_drawing

@onready var upgrade_manager: UpgradeManager = %UpgradeManager
@onready var score_manager: ScoreManager = %ScoreManager
@onready var drawing_manager: DrawingManager = %DrawingManager
@onready var input_manager: InputManager = %InputManager
@onready var player_drawing: PlayerDrawing = %PlayerDrawing
@onready var countdown_manager: CountdownManager = %CountdownManager
@onready var accuracy_manager: AccuracyManager = %AccuracyManager
@onready var hud: HUD = %HUD

func _ready() -> void:
    drawing_manager.set_next_drawing()
    
    # Register player inputs
    hud.submit_drawing.connect(_on_submit_drawing)
    hud.clear_drawing.connect(_on_clear_drawing)
    hud.select_tool.connect(_on_select_tool)
    hud.select_color.connect(_on_select_color)
    
    # HUD should only listen to game signals, pass everything up
    score_manager.update_score.connect(_on_update_score)
    input_manager.draw.connect(_on_draw)
    input_manager.submit_drawing.connect(_on_submit_drawing)
    input_manager.select_tool.connect(_on_select_tool)
    input_manager.select_color_index.connect(_on_select_color_index)
    
func _calculate_score() -> int:
    var user_array: PackedInt64Array = player_drawing.pack_image()
    var accuracy := drawing_manager.calculate_accuracy(user_array)
    print("Accuracy: ", accuracy)
    var drawing_info := drawing_manager.get_drawing_info()
    # TODO: Time bonus for doing it quickly?
    # TODO: Set bonus for doing a more complex drawing
    # TODO: Gain 100 or 1000 points max?
    return 5

func _get_accuracy() -> float:
    var user_array: PackedInt64Array = player_drawing.pack_image()
    var accuracy := drawing_manager.calculate_accuracy(user_array)
    
    return accuracy

func _on_submit_drawing() -> void:
    var score_earned := _calculate_score()
    var accuracy = _get_accuracy()
    
    score_manager.add_score(score_earned)
    player_drawing.reset_image()
    drawing_manager.set_next_drawing()
    submit_drawing.emit()
    countdown_manager.add_time(accuracy)
    accuracy_manager.update_accuracy(accuracy)
    
func _on_clear_drawing() -> void:
    player_drawing.reset_image()

func _on_update_score(score: int) -> void:
    update_score.emit(score)

func _on_draw(draw_pos: Vector2i) -> void:
    player_drawing.on_draw(draw_pos)

func _on_select_tool(tool: PlayerDrawing.Tool) -> void:
    player_drawing.set_selected_tool(tool)
    
func _on_select_color(color: Color) -> void:
    player_drawing.set_brush_color(color)

func _on_select_color_index(index: int) -> void:
    hud.select_color_index(index)
