class_name CountdownTimer
extends Control

@onready var time_label: Label = %TimeLabel
@onready var added_label: Label = %AddedLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var full_anim_player: AnimationPlayer = %FullAnimPlayer

const RED_TEXT_THRESHOLD := 5

var displayed_time_left: int

# When time changes in a big way, use this to show the delta
func change_time(delta_time: int):
    if delta_time >= 0:
        added_label.text = "+%ss" % (delta_time)
        if displayed_time_left == CountdownManager.MAX_TIME:
            full_anim_player.play("time_full")
        animation_player.play("adding_time")
        added_label.add_theme_color_override("font_color", Color.GREEN)
        if delta_time == 0:
            animation_player.play("zero_time")
            added_label.add_theme_color_override("font_color", Color.RED)
    elif delta_time < 0:
        added_label.text = "-%ss" % (-delta_time)
        animation_player.play("adding_time")
        added_label.add_theme_color_override("font_color", Color.RED)

func update_displayed_time(time_left: int):
    displayed_time_left = max(0, time_left)
    if displayed_time_left <= RED_TEXT_THRESHOLD:
        time_label.self_modulate = Color.RED
    else:
        time_label.self_modulate = Color.WHITE
    time_label.text = "%ss" % displayed_time_left
    AudioManager.adjust_tick_tock_db(displayed_time_left)

    
