class_name CountdownTimer
extends Control

@onready var time_label: Label = %TimeLabel
@onready var added_label: Label = %AddedLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer


var time_left: int = 10:
    set(value):
        var time_gained = value - time_left
        if time_gained >= 0:
            added_label.text = "+%ss" % (time_gained)
            animation_player.play("adding_time")
            added_label.add_theme_color_override("font_color", Color.GREEN)
            if time_gained == 0:
                added_label.add_theme_color_override("font_color", Color.RED)
            
        time_left = value
        time_label.text = "%ss" % time_left
        if value <= 3:
            time_label.self_modulate = Color.RED
        else:
            time_label.self_modulate = Color.WHITE
        
        AudioManager.adjust_tick_tock_db(time_left)

func _on_timer_timeout() -> void:
    time_left -= 1
    
