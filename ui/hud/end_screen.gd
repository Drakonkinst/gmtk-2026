class_name EndScreen
extends Control

@onready var leaderboard_scene : PackedScene = preload("uid://cppg62i68ikb7")
@onready var menu_scene : PackedScene = preload("uid://00bxfurateyx")
@onready var blur_rect: ColorRect = %BlurRect
@onready var user_entry: LineEdit = %UserEntry
@onready var post_button: Button = %PostButton
@onready var menu_button: Button = %MenuButton
@onready var replay_button: Button = %ReplayButton
@onready var end_anim_player: AnimationPlayer = %EndAnimPlayer
@onready var leaderboard: Leaderboard = %Leaderboard

@onready var end_score_value: Label = %EndScoreValue
@onready var end_accuracy_value: Label = %EndAccuracyValue
@onready var end_time_spent: Label = %EndTimeSpent
@onready var end_drawings_completed: Label = %EndDrawingsCompleted

var score_posted := false

func _ready() -> void:
    post_button.pressed.connect(_on_post_button_pressed)
    menu_button.pressed.connect(_on_menu_button_pressed)
    replay_button.pressed.connect(_on_replay_button_pressed)
    user_entry.text = Global.user_name
    
func _on_post_button_pressed() -> void:
    if score_posted or len(user_entry.text) <= 0:
        return
    score_posted = true
    Global.user_name = user_entry.text
    leaderboard.post_score()
    post_button.disabled = true
    user_entry.editable = false

func _on_menu_button_pressed() -> void:
    Global.game.exit_game.emit()
    
func _on_replay_button_pressed() -> void:
    Global.game.restart_game.emit()
    
func on_game_end() -> void:
    show()
    end_score_value.text = str(Global.score)
    end_accuracy_value.text = Global.average_accuracy_str
    end_time_spent.text = Global.total_time_str
    end_drawings_completed.text = str(Global.drawings_made)
    
    end_anim_player.play("end_game")
    
