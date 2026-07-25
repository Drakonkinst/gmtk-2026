extends Control

@onready var scores_container := %ScoresContainer as VBoxContainer
@onready var single_score : PackedScene = preload("uid://dlvrj547ca4f6")
@onready var loading_label := %LoadingLabel as Label
@onready var high_scores_label := %HighScoresLabel as Label
@onready var switch : Button = %Switch
@onready var sfx : AudioStreamPlayer = $uisfx
@onready var sfx_hover : AudioStreamPlayer = $uiHoversfx


func _ready() -> void:
    if Global.posting_score:
        await Talo.players.identify('user_name', Global.user_name)
        await Talo.leaderboards.add_entry('leaderboard', Global.score, { user_name = Global.user_name })
        Global.posting_score = false
    get_scores()

func _on_button_pressed() -> void:
    sfx.play()
    await get_tree().create_timer(0.2).timeout
    get_tree().change_scene_to_file("uid://dwl71rxjb5i4j")

func _on_timer_timeout() -> void:
    if loading_label.text.length() > 9:
        loading_label.text = 'LOADING'
    else:
        loading_label.text = loading_label.text + '.'

func get_scores():
    loading_label.visible = true
    var results = await Talo.leaderboards.get_entries('leaderboard')
    loading_label.visible = false
    var entries = results['entries']

    for entry in entries:
        var new_score = single_score.instantiate()
        scores_container.add_child(new_score)
        new_score.constructor({ 'rank': entry.position + 1, 'score': entry.score, 'name': entry.get_prop('user_name') })

func _on_button_mouse_entered() -> void:
    sfx_hover.play()
