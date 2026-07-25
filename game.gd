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

const DEBUG_MODE := false # TODO: Make everything free if this is on

func _ready() -> void:
    drawing_manager.set_next_drawing()
    
    # Register player inputs
    hud.submit_drawing.connect(_on_submit_drawing)
    hud.clear_drawing.connect(_on_clear_drawing)
    hud.select_tool.connect(_on_select_tool)
    hud.select_color.connect(_on_select_color)
    hud.select_size.connect(_on_select_size)
    
    # HUD should only listen to game signals, pass everything up
    score_manager.update_score.connect(_on_update_score)
    input_manager.draw.connect(_on_draw)
    input_manager.submit_drawing.connect(_on_submit_drawing)
    input_manager.select_tool.connect(_on_select_tool)
    input_manager.select_color_index.connect(_on_select_color_index)
    upgrade_manager.attempt_upgrade_1.connect(_on_attempt_upgrade_1)
    upgrade_manager.attempt_upgrade_2.connect(_on_attempt_upgrade_2)
    
    countdown_manager.countdown_timer.game_lose.connect(_on_game_lose)
    
    AudioManager.play_tick_tock_sfx()
    
func _calculate_score(accuracy: float) -> int:
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
    var accuracy := _get_accuracy()
    print("Accuracy: ", accuracy)
    var score_earned := _calculate_score(accuracy)
    
    score_manager.add_score(score_earned)
    player_drawing.reset_image()
    drawing_manager.set_next_drawing()
    submit_drawing.emit()
    countdown_manager.add_time(accuracy)
    accuracy_manager.update_accuracy(accuracy)
    
    AudioManager.play_submit_sfx()
    if accuracy >= 0.2:
        AudioManager.play_good_sfx(accuracy)
    else:
        AudioManager.play_bad_sfx(accuracy)
    
func _on_clear_drawing() -> void:
    player_drawing.reset_image()
    AudioManager.play_clear_sfx()

func _on_update_score(score: int) -> void:
    update_score.emit(score)

func _on_draw(draw_pos: Vector2i) -> void:
    player_drawing.on_draw(draw_pos)

func _on_select_tool(tool: PlayerDrawing.Tool) -> void:
    if tool == player_drawing.selected_tool: return
    
    player_drawing.set_selected_tool(tool)
    AudioManager.play_button_sfx()
    AudioManager.play_brush_select_sfx()
    
func _on_select_color(color: Color) -> void:
    if color == player_drawing.brush_color: return
    
    player_drawing.set_brush_color(color)
    AudioManager.play_button_sfx()
    AudioManager.play_color_select_sfx()

func _on_select_color_index(index: int) -> void:
    hud.select_color_index(index)

func _on_select_size(size: PlayerDrawing.BrushSize) -> void:
    if size == player_drawing.brush_size: return
    
    player_drawing.set_brush_size(size)
    AudioManager.play_button_sfx()
    AudioManager.play_brush_select_sfx()

func _on_game_lose() -> void:
    AudioManager.play_time_up_sfx()
    
func _on_attempt_upgrade_1(upgrade: Upgrade) -> void:
    if _has_enough_time(upgrade.cost):
        _spend_time(upgrade.cost)
        upgrade_manager.unlock_upgrade_1()

func _on_attempt_upgrade_2(upgrade: Upgrade) -> void:
    if _has_enough_time(upgrade.cost):
        _spend_time(upgrade.cost)
        upgrade_manager.unlock_upgrade_2()

func _has_enough_time(seconds: int) -> bool:
    return DEBUG_MODE or countdown_manager.get_seconds_left()

func _spend_time(seconds: int) -> void:
    if not DEBUG_MODE:
        countdown_manager.spend_seconds(seconds)
