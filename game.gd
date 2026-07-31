extends Node2D

class_name Game

signal exit_game
signal restart_game
signal update_score(score: int)
signal complete_drawing

const MAX_DRAWINGS := 20

@onready var upgrade_manager: UpgradeManager = %UpgradeManager
@onready var score_manager: ScoreManager = %ScoreManager
@onready var drawing_manager: DrawingManager = %DrawingManager
@onready var input_manager: InputManager = %InputManager
@onready var player_drawing: PlayerDrawing = %PlayerDrawing
@onready var countdown_manager: CountdownManager = %CountdownManager
@onready var hud: HUD = %HUD
@onready var end_screen: EndScreen = %EndScreen

const DEBUG_MODE := false
const ACCURACY_THRESHOLD := 0.5

var freedraw_mode := Global.freedraw_mode
var drawings_completed := 0
var accuracy_sum := 0.0 # Can use this to calculate average accuracy with accuracy_sum / drawings_completed
var total_time_spent := 0.0 # Can use for leaderboard
var game_over := false

func _ready() -> void:
    drawing_manager.set_next_drawing()
    end_screen.hide()
    
    # Register player inputs
    hud.submit_drawing.connect(_on_submit_drawing)
    hud.clear_drawing.connect(_on_clear_drawing)
    hud.select_tool.connect(_on_select_tool)
    hud.select_color.connect(_on_select_color)
    hud.select_size.connect(_on_select_size)
    if freedraw_mode:
        hud.on_freedraw_mode()
    
    # HUD should only listen to game signals, pass everything up
    score_manager.update_score.connect(_on_update_score)
    input_manager.draw.connect(_on_draw)
    input_manager.submit_drawing.connect(_on_submit_drawing)
    input_manager.select_tool.connect(_on_select_tool)
    input_manager.select_color_index.connect(_on_select_color_index)
    upgrade_manager.attempt_upgrade_1.connect(_on_attempt_upgrade_1)
    upgrade_manager.attempt_upgrade_2.connect(_on_attempt_upgrade_2)
    input_manager.scroll_changed.connect(_on_scroll_change)
    
    countdown_manager.game_lose.connect(_on_game_lose)
    
    AudioManager.play_tick_tock_sfx()

func _process(delta: float) -> void:
    total_time_spent += delta

func _calculate_score(accuracy: float) -> int:
    var time_spent := player_drawing.time_since_drawing_started
    var drawing_info := drawing_manager.get_drawing_info()
    return score_manager.calculate_score(accuracy, time_spent, drawing_info)

func _get_accuracy() -> float:
    var user_array: PackedInt64Array = player_drawing.pack_image()
    var accuracy := drawing_manager.calculate_accuracy(user_array)
    return accuracy

func _on_submit_drawing() -> void:
    drawings_completed += 1
    var accuracy := _get_accuracy()
    print("Accuracy: ", accuracy)
    accuracy_sum += accuracy
    var score_earned := _calculate_score(accuracy)
    
    score_manager.add_score(score_earned)
    player_drawing.on_new_drawing()
    drawing_manager.set_next_drawing()
    countdown_manager.add_time(accuracy)
    hud.on_complete_drawing(accuracy)
    
    AudioManager.play_submit_sfx()
    if accuracy >= ACCURACY_THRESHOLD:
        AudioManager.play_good_sfx(accuracy)
        %Hourglass.add_sand()
    else:
        AudioManager.play_bad_sfx(accuracy)
        
    
    
    complete_drawing.emit()
    if drawings_completed >= MAX_DRAWINGS and not Global.freedraw_mode:
        _on_game_lose()
    
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
    if size == player_drawing.brush_size_label:
        return
    
    player_drawing.set_brush_size(size)
    AudioManager.play_button_sfx()
    AudioManager.play_brush_select_sfx()

func _on_game_lose() -> void:
    game_over = true
    input_manager.drawing_enabled = false
    hud.on_game_lose()
    AudioManager.play_time_up_sfx()
    
    # Calculate endgame stats
    Global.drawings_made = drawings_completed
    if drawings_completed > 0:
        var overall_accuracy := accuracy_sum / drawings_completed
        var accuracy_as_int := int(overall_accuracy * 100)
        Global.average_accuracy_str = str(accuracy_as_int) + "%"
    else:
        Global.average_accuracy_str = "0%"
    var num_minutes := int(total_time_spent / 60)
    var num_seconds := int(total_time_spent) - num_minutes * 60
    Global.total_time_str = str(num_minutes) + "m " + str(num_seconds) + "s"
    
    end_screen.on_game_end()
    
func _on_upgrade_unlock(upgrade: Upgrade) -> void:
    hud.on_upgrade_unlocked(upgrade)
    AudioManager.play_button_sfx()
    %Hourglass.take_sand()
    AudioManager.play_unlock_sfx()

func _on_attempt_upgrade_1(upgrade: Upgrade) -> void:
    if _has_enough_time(upgrade.cost):
        _spend_time(upgrade.cost)
        upgrade_manager.unlock_upgrade_1()
        _on_upgrade_unlock(upgrade)

func _on_attempt_upgrade_2(upgrade: Upgrade) -> void:
    if _has_enough_time(upgrade.cost):
        _spend_time(upgrade.cost)
        upgrade_manager.unlock_upgrade_2()
        _on_upgrade_unlock(upgrade)

func _has_enough_time(seconds: int) -> bool:
    return DEBUG_MODE or countdown_manager.get_seconds_left()

func _spend_time(seconds: int) -> void:
    if not DEBUG_MODE:
        countdown_manager.change_time_big(-seconds)

func _on_scroll_change(dir: int) -> void:
    if dir > 0:
        player_drawing.increment_size()
    else:
        player_drawing.decrement_size()

func exit_to_menu():
    for button: BaseButton in [%RestartButton,%PausedMenuButton,%BackButton]:
        button.disabled = true
    %TransitionAnimation.play_backwards("transition")
    await %TransitionAnimation.animation_finished
    AudioManager.stop_tick_tock_sfx()
    exit_game.emit()

func restart():
    restart_game.emit()
