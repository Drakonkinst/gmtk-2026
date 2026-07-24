extends Control

class_name ColorSelect

signal select_color(color: Color)

@export var buttons: Array[TextureButton]
var colors: Array[Color]

func _ready() -> void:
    var index := 0
    for button in buttons:
        button.pressed.connect(_on_button_pressed.bind(index))
        var texture_rect: TextureRect = button.get_node("TextureRect")
        var color: Color = texture_rect.modulate
        colors.push_back(color)
        index += 1
    print(colors)

func _on_button_pressed(index: int) -> void:
    select_color.emit(colors[index])

func _process(delta: float) -> void:
    update_button_states()

func select_color_index(index: int) -> void:
    if index >= 0 and index < len(colors):
        _on_button_pressed(index)
    
func update_button_states() -> void:
    # TODO: This entire element should only be shown once colors are unlocked?
    var player_drawing: PlayerDrawing = Global.game.player_drawing
    var upgrade_manager: UpgradeManager = Global.game.upgrade_manager
    var selected_color := player_drawing.brush_color
    for i in range(len(buttons)):
        var button := buttons[i]
        var color := colors[i]
        button.disabled = selected_color == color 
    
    