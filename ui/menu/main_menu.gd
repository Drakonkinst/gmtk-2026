extends Node

class_name MainMenu

signal start_game

func _ready() -> void:
    get_tree().paused = false
    AudioManager.start_bgm()
    # Show menus and connect buttons
    %StartButton.pressed.connect(_on_startbutton_pressed)
    %CreditsButton.pressed.connect(_on_creditsbutton_pressed)
    %BackButton.pressed.connect(_on_backbutton_pressed)
    
    # can't press buttons until animation ended
    await %AnimationPlayer.animation_finished
    %Fader.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
    
func _on_startbutton_pressed():
    AudioManager.play_button_sfx()
    start_game.emit()

func _on_creditsbutton_pressed():
    if %Background.modulate == Color(1.0, 1.0, 1.0, 1.0):
        AudioManager.play_button_sfx()
        var tween = get_tree().create_tween().set_parallel(true)
        tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
        tween.tween_property(%Credits,"position:y",0.0,1.0)
        tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
        tween.tween_property(%Background,"modulate",Color(0.5, 0.5, 0.5, 1.0),1.0)
        
        var menu_tween = get_tree().create_tween().set_parallel(false)
        menu_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
        for node: CanvasItem in [%Title,%StartButton,%OptionsButton,%CreditsButton]:
            menu_tween.tween_property(node,"position:x", node.position.x - 1000,0.1)
        
    
func _on_backbutton_pressed():
    if %Background.modulate == Color(0.5, 0.5, 0.5, 1.0):
        AudioManager.play_button_sfx()
        var tween = get_tree().create_tween().set_parallel(true)
        tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
        tween.tween_property(%Credits,"position:y",-720.0,0.5)
        tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
        tween.tween_property(%Background,"modulate",Color(1.0, 1.0, 1.0, 1.0),1.0)
        
        var menu_tween = get_tree().create_tween().set_parallel(false)
        menu_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
        for node: CanvasItem in [%StartButton,%OptionsButton,%CreditsButton,%Title]:
            menu_tween.tween_property(node,"position:x", node.position.x + 1000,0.2)
