extends Control

class_name SizeSelect

signal select_size(size: PlayerDrawing.BrushSize)

@onready var small_button: TextureButton = %SmallBrushButton
@onready var normal_button: TextureButton = %NormalBrushButton
@onready var large_button: TextureButton = %LargeBrushButton

var button_map: Dictionary

func _ready() -> void:
    button_map[PlayerDrawing.BrushSize.SMALL] = small_button
    button_map[PlayerDrawing.BrushSize.NORMAL] = normal_button
    button_map[PlayerDrawing.BrushSize.LARGE] = large_button
    
    for brush_size in button_map.keys():
        var button: TextureButton = button_map[brush_size]
        button.pressed.connect(_on_button_pressed.bind(brush_size))
        
func _on_button_pressed(brush_size: PlayerDrawing.BrushSize) -> void:
    select_size.emit(brush_size)
    
func _process(delta: float) -> void:
    update_button_states()

func update_button_states() -> void:
    var player_drawing: PlayerDrawing = Global.game.player_drawing
    for brush_size in button_map.keys():
        var button: TextureButton = button_map[brush_size]
        button.disabled = brush_size == player_drawing.brush_size_label
