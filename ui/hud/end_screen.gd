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

@onready var header: Label = %Header
@onready var end_score_value: Label = %EndScoreValue
@onready var end_accuracy_value: Label = %EndAccuracyValue
@onready var end_time_spent: Label = %EndTimeSpent
@onready var end_drawings_completed: Label = %EndDrawingsCompleted
@onready var end_drawings_max: Label = %EndDrawingsMax

var score_posted := false

var displayed_score := 0
const SCORE_PER_SECOND := 10000
const MAX_DELAY := 1.5
var target_score := 0
var delay_left := 0.0

func _ready() -> void:
    post_button.pressed.connect(_on_post_button_pressed)
    menu_button.pressed.connect(_on_menu_button_pressed)
    replay_button.pressed.connect(_on_replay_button_pressed)
    user_entry.text = Global.user_name
    
func _process(delta: float) -> void:
    if delay_left > 0:
        delay_left -= delta
    else:
        if displayed_score < target_score:
            displayed_score = min(displayed_score + SCORE_PER_SECOND * delta, target_score)
        end_score_value.text = str(displayed_score)
    
func _on_post_button_pressed() -> void:
    if score_posted or len(user_entry.text) <= 0:
        return
    score_posted = true
    Global.user_name = user_entry.text
    leaderboard.post_score()
    post_button.disabled = true
    user_entry.editable = false

func _on_menu_button_pressed() -> void:
    for button: BaseButton in [%MenuButton,%ReplayButton]:
        button.disabled = true
    %TransitionAnimation.play_backwards("transition")
    await %TransitionAnimation.animation_finished
    Global.game.exit_game.emit()
    
func _on_replay_button_pressed() -> void:
    Global.game.restart_game.emit()
    AudioManager.start_bgm()
    
func on_game_end(reached_drawing_limit: bool = false) -> void:
    show()
    displayed_score = 0
    delay_left = MAX_DELAY
    target_score = Global.score
    end_accuracy_value.text = Global.average_accuracy_str
    end_time_spent.text = Global.total_time_str
    end_drawings_completed.text = str(Global.drawings_made)
    end_drawings_max.text = "/ " + str(Global.game.MAX_DRAWINGS)
    
    if reached_drawing_limit:
        header.text = "Finished!"
        AudioManager.play_draw_limit_sfx()
    else:
        AudioManager.play_time_up_sfx()

    end_anim_player.play("end_game")
    AudioManager.start_pause_bgm()
    
