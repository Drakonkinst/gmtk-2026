class_name EndScreen
extends Control

@onready var leaderboard_scene : PackedScene = preload("uid://cppg62i68ikb7")
@onready var menu_scene : PackedScene = preload("uid://00bxfurateyx")
@onready var blur_rect: ColorRect = %BlurRect
@onready var user_entry: LineEdit = %UserEntry
@onready var post_button: Button = %PostButton
@onready var menu_button: Button = %MenuButton
@onready var replay_button: Button = %ReplayButton
@onready var end_score_value: Label = %EndScoreValue
@onready var end_anim_player: AnimationPlayer = %EndAnimPlayer


func _ready() -> void:
    post_button.pressed.connect(_on_post_button_pressed)
    menu_button.pressed.connect(_on_menu_button_pressed)
    replay_button.pressed.connect(_on_replay_button_pressed)
    
func _on_post_button_pressed() -> void:
    Global.posting_score = true
    Global.user_name = user_entry.text
    get_tree().change_scene_to_packed(leaderboard_scene)

func _on_menu_button_pressed() -> void:
    Global.game.exit_game.emit()
    
func _on_replay_button_pressed() -> void:
    Global.game.restart_game.emit()
    
func on_game_end() -> void:
    show()
    end_score_value.text = str(Global.score)
    end_anim_player.play("end_game")
    
