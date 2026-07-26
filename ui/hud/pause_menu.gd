class_name PauseMenu
extends Control

@onready var pause_button: Button = %PauseButton
@onready var paused_menu_button: Button = %PausedMenuButton
@onready var restart_button: Button = %RestartButton
@onready var back_button: Button = %BackButton

func _ready() -> void:
    pause_button.pressed.connect(_on_pause_button_pressed)
    paused_menu_button.pressed.connect(_on_paused_menu_button_pressed)
    restart_button.pressed.connect(_on_restart_button_pressed)
    back_button.pressed.connect(_on_back_button_pressed)
    
    pause_button.mouse_entered.connect(_on_button_mouse_entered)
    paused_menu_button.mouse_entered.connect(_on_button_mouse_entered)
    restart_button.mouse_entered.connect(_on_button_mouse_entered)
    back_button.mouse_entered.connect(_on_button_mouse_entered)
    
func _unhandled_input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("pause"):
        if !visible:
            pause()
        else:
            unpause()

func pause() -> void:
    get_tree().paused = true
    show()
    AudioManager.start_pause_bgm()

func unpause() -> void:
    get_tree().paused = false
    hide()
    AudioManager.start_bgm()

func _on_pause_button_pressed() -> void:
    AudioManager.play_button_sfx()
    get_tree().paused = true
    show()
    
func _on_paused_menu_button_pressed() -> void:
    AudioManager.play_button_sfx()
    Global.game.exit_to_menu()
    
func _on_restart_button_pressed() -> void:
    AudioManager.play_button_sfx()
    Global.game.restart()

func _on_back_button_pressed() -> void:
    AudioManager.play_button_sfx()
    get_tree().paused = false
    hide()

func _on_button_mouse_entered() -> void:
    AudioManager.play_hover_sfx()
