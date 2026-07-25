extends Control

class_name Leaderboard

@onready var scores_container := %ScoresContainer as VBoxContainer
@onready var single_score: PackedScene = preload("uid://dlvrj547ca4f6")
@onready var loading_label := %LoadingLabel as Label
@onready var high_scores_label := %HighScoresLabel as Label
@onready var switch : Button = %Switch
@onready var sfx : AudioStreamPlayer = $uisfx
@onready var sfx_hover : AudioStreamPlayer = $uiHoversfx

func _ready() -> void:
    refresh_scores()

func post_score() -> void:
    for child in scores_container.get_children():
        # Be free!
        child.queue_free()
    loading_label.visible = true
    await Talo.players.identify('user_name', Global.user_name)
    await Talo.leaderboards.add_entry('leaderboard', Global.score, { user_name = Global.user_name })
    Global.posting_score = false
    refresh_scores()

func refresh_scores():
    loading_label.visible = true
    var results = await Talo.leaderboards.get_entries('leaderboard')
    loading_label.visible = false
    var entries = results['entries']

    for entry in entries:
        var new_score := single_score.instantiate()
        scores_container.add_child(new_score)
        new_score.constructor({ 'rank': entry.position + 1, 'score': entry.score, 'name': entry.get_prop('user_name') })
