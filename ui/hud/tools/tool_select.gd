extends Control

class_name ToolSelect

signal tool_button_pressed(tool: PlayerDrawing.Tool)

@onready var brush_button: TextureButton = %BrushButton
@onready var eraser_button: TextureButton = %EraserButton

var button_map: Dictionary

func _ready() -> void:
    button_map[PlayerDrawing.Tool.BRUSH] = brush_button
    button_map[PlayerDrawing.Tool.ERASER] = eraser_button
    
    for tool in button_map.keys():
        var button: TextureButton = button_map[tool]
        button.pressed.connect(_on_button_pressed.bind(tool))
        
func _on_button_pressed(tool: PlayerDrawing.Tool) -> void:
    tool_button_pressed.emit(tool)
    
func _process(delta: float) -> void:
    update_button_states()

func update_button_states() -> void:
    var player_drawing: PlayerDrawing = Global.game.player_drawing
    var upgrade_manager: UpgradeManager = Global.game.upgrade_manager
    var selected_tool := player_drawing.get_current_tool()
    for tool in button_map.keys():
        var button: TextureButton = button_map[tool]
        button.disabled = (tool == selected_tool) or not upgrade_manager.unlocked_tools[tool]
