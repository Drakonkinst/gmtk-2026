extends Node

class_name MainMenu

signal start_game

@onready var volume_sliders: Control = %VolumeSliders
@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var options_button: Button = %OptionsButton
@onready var back_button: Button = %BackButton
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var background: TextureRect = %Background
@onready var credits: Control = %Credits
@onready var fader: ColorRect = %Fader
@onready var title: Sprite2D = %Title


func _ready() -> void:
    get_tree().paused = false
    AudioManager.start_bgm()
    # Show menus and connect buttons
    start_button.pressed.connect(_on_start_button_pressed)
    credits_button.pressed.connect(_on_credits_button_pressed)
    options_button.pressed.connect(_on_options_button_pressed)
    back_button.pressed.connect(_on_backbutton_pressed)
    
    start_button.mouse_entered.connect(_on_start_button_mouse_entered)
    credits_button.mouse_entered.connect(_on_credits_button_mouse_entered)
    options_button.mouse_entered.connect(_on_options_button_mouse_entered)
    back_button.mouse_entered.connect(_on_back_button_mouse_entered)
    
    # can't press buttons until animation ended
    await animation_player.animation_finished
    fader.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
    
func _on_start_button_pressed():
    AudioManager.play_button_sfx()
    start_game.emit()

func _on_credits_button_pressed():
    AudioManager.play_button_sfx()
    volume_sliders.hide()
    
    if background.modulate == Color(1.0, 1.0, 1.0, 1.0):
        AudioManager.play_button_sfx()
        var tween = get_tree().create_tween().set_parallel(true)
        tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
        tween.tween_property(credits,"position:y",0.0,1.0)
        tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
        tween.tween_property(background,"modulate",Color(0.5, 0.5, 0.5, 1.0),1.0)
        
        var menu_tween = get_tree().create_tween().set_parallel(false)
        menu_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
        for node: CanvasItem in [title,start_button,options_button,credits_button]:
            menu_tween.tween_property(node,"position:x", node.position.x - 1000,0.1)
        
func _on_options_button_pressed():
    AudioManager.play_button_sfx()
    
func _on_backbutton_pressed():    
    AudioManager.play_button_sfx()
    volume_sliders.show()

    if background.modulate == Color(0.5, 0.5, 0.5, 1.0):
        AudioManager.play_button_sfx()
        var tween = get_tree().create_tween().set_parallel(true)
        tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
        tween.tween_property(credits,"position:y",-720.0,0.5)
        tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
        tween.tween_property(background,"modulate",Color(1.0, 1.0, 1.0, 1.0),1.0)
        
        var menu_tween = get_tree().create_tween().set_parallel(false)
        menu_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
        for node: CanvasItem in [start_button,options_button,credits_button,title]:
            menu_tween.tween_property(node,"position:x", node.position.x + 1000,0.2)
    
func _on_start_button_mouse_entered() -> void:
    AudioManager.play_hover_sfx()
    
func _on_credits_button_mouse_entered() -> void:
    AudioManager.play_hover_sfx()
    
func _on_options_button_mouse_entered():
    AudioManager.play_hover_sfx()

func _on_back_button_mouse_entered() -> void:
    AudioManager.play_hover_sfx()
