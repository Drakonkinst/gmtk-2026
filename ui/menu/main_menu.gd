extends Node

class_name MainMenu

signal start_game

@onready var volume_sliders: Control = %VolumeSliders
@onready var start_button: Button = %StartButton
@onready var credits_button: Button = %CreditsButton
@onready var freedraw_button: Button = %FreedrawButton
@onready var back_button: Button = %BackButton
@onready var options_button: Button = %OptionsButton
@onready var options_menu: Control = %OptionsMenu
@onready var options_bg: ColorRect = %OptionsBG
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var background: TextureRect = %Background
@onready var credits: Control = %Credits
@onready var fader: ColorRect = %Fader
@onready var title: AnimatedSprite2D = %Title
var restarting: bool = false

func _ready() -> void:
    get_tree().paused = false
    if !restarting:
        AudioManager.start_bgm(true)
    # Show menus and connect buttons
    start_button.pressed.connect(_on_start_button_pressed)
    credits_button.pressed.connect(_on_credits_button_pressed)
    options_button.pressed.connect(_on_options_button_pressed)
    back_button.pressed.connect(_on_backbutton_pressed)
    freedraw_button.pressed.connect(_on_freedraw_button_pressed)
    
    start_button.mouse_entered.connect(_on_button_mouse_entered)
    credits_button.mouse_entered.connect(_on_button_mouse_entered)
    options_button.mouse_entered.connect(_on_button_mouse_entered)
    back_button.mouse_entered.connect(_on_button_mouse_entered)
    freedraw_button.mouse_entered.connect(_on_button_mouse_entered)
    
    options_bg.mouse_exited.connect(_on_options_bg_mouse_exited)
    %HSlider2.value_changed.connect(_on_musicslider_value_changed)
    
    # can't press buttons until animation ended
    await animation_player.animation_finished
    fader.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
    
func _on_start_button_pressed():
    AudioManager.play_button_sfx()
    Global.freedraw_mode = false
    for button: BaseButton in [start_button,options_button,credits_button,freedraw_button]:
        button.disabled = true
    %AnimationPlayer.play("transition")
    await %AnimationPlayer.animation_finished
    start_game.emit()

func _on_freedraw_button_pressed():
    AudioManager.play_button_sfx()
    Global.freedraw_mode = true
    for button: BaseButton in [start_button,options_button,credits_button,freedraw_button]:
        button.disabled = true
    %AnimationPlayer.play("transition")
    await %AnimationPlayer.animation_finished
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
        for node: CanvasItem in [title,start_button,options_button,credits_button,freedraw_button]:
            menu_tween.tween_property(node,"position:x", node.position.x - 1000,0.075)
        
func _on_options_button_pressed():
    AudioManager.play_button_sfx()
    options_menu.show()

func _on_options_bg_mouse_exited():
    if not options_bg.get_global_rect().has_point(get_viewport().get_mouse_position()):
        AudioManager.play_hover_sfx()
        options_menu.hide()
    
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
        for node: CanvasItem in [options_button,credits_button,freedraw_button,title,start_button]:
            menu_tween.tween_property(node,"position:x", node.position.x + 1000,0.25)
    
func _on_button_mouse_entered() -> void:
    if not %AnimationPlayer.is_playing():
        AudioManager.play_hover_sfx()
        
func _on_musicslider_value_changed(value):
    if value == 0:
        %Label2.text = "bruh"
    else:
        %Label2.text = "Music Volume"
