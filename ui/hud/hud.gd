extends Control

class_name HUD

signal submit_drawing
signal clear_drawing
signal select_tool(tool: PlayerDrawing.Tool)
signal select_color(color: Color)
signal select_size(size: PlayerDrawing.BrushSize)

@onready var score_counter: ScoreCounter = %ScoreCounter
@onready var submit_button: Button = %SubmitButton
@onready var clear_button: TextureButton = %ClearButton
@onready var tool_select: ToolSelect = %ToolSelect
@onready var color_select: ColorSelect = %ColorSelect
@onready var size_select: SizeSelect = %SizeSelect
@onready var reveal_elements: RevealElements = %RevealElements
@onready var accuracy_display: RichTextLabel = %AccuracyValue
@onready var drawing_count: RichTextLabel = %DrawingCount
@onready var hourglass: Hourglass = %Hourglass
@onready var countdown_timer: CountdownTimer = %CountdownTimer


func _ready() -> void:
    submit_button.pressed.connect(_on_submit_button_pressed)
    clear_button.pressed.connect(_on_clear_button_pressed)
    tool_select.tool_button_pressed.connect(_on_tool_button_pressed)
    color_select.select_color.connect(_on_select_color)
    size_select.select_size.connect(_on_select_size)
    score_counter.set_multiplier(1.0)
    
func on_upgrade_unlocked(upgrade: Upgrade) -> void:
    reveal_elements.on_upgrade_unlocked(upgrade)
    score_counter.set_multiplier(Global.game.upgrade_manager.score_multiplier)

func on_complete_drawing(accuracy: float) -> void:
    accuracy_display.text = str(int(accuracy * 100)) + "%"
    var drawings_completed_text := str(min(Global.game.drawings_completed + 1, Global.game.MAX_DRAWINGS))
    if Global.game.freedraw_mode:
        drawing_count.text = drawings_completed_text
    else:
        drawing_count.text =  drawings_completed_text + " / " + str(Global.game.MAX_DRAWINGS)

func select_color_index(index: int) -> void:
    color_select.select_color_index(index)

func _on_tool_button_pressed(tool: PlayerDrawing.Tool) -> void:
    select_tool.emit(tool)

func _on_submit_button_pressed() -> void:
    submit_drawing.emit()

func on_game_end() -> void:
    submit_button.disabled = true
    clear_button.disabled = true
    #AudioManager.start_pause_bgm()

func on_freedraw_mode() -> void:
    drawing_count.text = "0"
    countdown_timer.hide()

func on_game_lose() -> void:
    on_game_end()
    hourglass.falling_sand.hide()

func _unhandled_input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("clear"):
        clear_drawing.emit()

func _on_clear_button_pressed() -> void:
    clear_drawing.emit()

func _on_select_color(color: Color) -> void:
    select_color.emit(color)

func _on_select_size(brush_size: PlayerDrawing.BrushSize) -> void:
    select_size.emit(brush_size)
