extends Control

@onready var player_entry: LineEdit = %PlayerEntry
@onready var post_button: Button = %PostButton
@onready var leaderboard_scene : PackedScene = preload("uid://cppg62i68ikb7")


func _ready() -> void:
    post_button.pressed.connect(_on_button_pressed)
    
func _on_button_pressed() -> void:
    Global.posting_score = true
    Global.user_name = player_entry.text
    get_tree().change_scene_to_packed(leaderboard_scene)
