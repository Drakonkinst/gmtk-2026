extends Node

# @onready var sound_effect: AudioRandomizer | AudioStreamPlayer | AudioRandomizer2D = %SoundEffect
#exports instead of onready to avoid errors with singleton loading
@export var submit_sfx: AudioStreamPlayer
@export var good_sfx: AudioStreamPlayer
@export var bad_sfx: AudioStreamPlayer
@export var button_sfx: AudioStreamPlayer
@export var bgm: AudioStreamPlayer


func play_submit_sfx() -> void:
    submit_sfx.play()

func play_good_sfx(accuracy: float) -> void:
    var pitch_shift: float = 0.5 + accuracy
    good_sfx.pitch_scale = pitch_shift
    good_sfx.play()

func play_bad_sfx(accuracy: float) -> void:
    var pitch_shift: float = 0.8 + accuracy
    bad_sfx.pitch_scale = pitch_shift
    bad_sfx.play()
    
func play_button_sfx() -> void:
    button_sfx.play()

func start_bgm() -> void:
    bgm.play()
