class_name CountdownTimer
extends Control

@onready var time_label: Label = %TimeLabel
var time_left: int = 10:
    set(value):
        time_left = value
        time_label.text = "%ss" % time_left
        

func _on_timer_timeout() -> void:
    time_left -= 1
    
