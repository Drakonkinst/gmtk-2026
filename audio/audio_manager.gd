extends Node

# @onready var sound_effect: AudioRandomizer | AudioStreamPlayer | AudioRandomizer2D = %SoundEffect
#exports instead of onready to avoid errors with singleton load order
@export var bgm: AudioStreamPlayer
@export var submit_sfx: AudioStreamPlayer
@export var good_sfx: AudioStreamPlayer
@export var bad_sfx: AudioStreamPlayer
@export var button_sfx: AudioStreamPlayer
@export var hover_sfx: AudioStreamPlayer
@export var draw_sfx: AudioStreamPlayer
@export var erase_sfx: AudioStreamPlayer
@export var clear_sfx: AudioStreamPlayer
@export var brush_select_sfx: AudioStreamPlayer
@export var color_select_sfx: AudioStreamPlayer
@export var bucket_fill_sfx: AudioStreamPlayer
@export var tick_tock_sfx: AudioStreamPlayer
@export var time_up_sfx: AudioStreamPlayer


func start_bgm() -> void:
    bgm.play()

func play_submit_sfx() -> void:
    submit_sfx.play()

func play_good_sfx(accuracy: float) -> void:
    #var pitch_shift: float = 0.5 + accuracy
    #good_sfx.pitch_scale = pitch_shift
    good_sfx.play()

func play_bad_sfx(accuracy: float) -> void:
    #var pitch_shift: float = 0.8 + accuracy
    #bad_sfx.pitch_scale = pitch_shift
    bad_sfx.play()
    
func play_button_sfx() -> void:
    button_sfx.play()
    
func play_hover_sfx() -> void:
    hover_sfx.play()

var starting_draw_db: float
var starting_draw_pitch: float
var times_played_recently: float = 0
func play_draw_sfx() -> void:
    if starting_draw_db == 0:
        starting_draw_db = draw_sfx.volume_db
        starting_draw_pitch = draw_sfx.pitch_scale
    draw_sfx.volume_db = starting_draw_db + sqrt(times_played_recently) / 2
    draw_sfx.pitch_scale = starting_draw_pitch + sqrt(times_played_recently / 10)
    draw_sfx.play()
    
    times_played_recently += 1
    await get_tree().create_timer(0.05).timeout
    times_played_recently -= 1
    
func play_erase_sfx() -> void:
    erase_sfx.play()

func play_clear_sfx() -> void:
    clear_sfx.play()

func play_brush_select_sfx() -> void:
    brush_select_sfx.play()
    
func play_color_select_sfx() -> void:
    color_select_sfx.play()

func play_bucket_fill_sfx() -> void:
    bucket_fill_sfx.play()

func adjust_tick_tock_db(time_left: int) -> void:
    var volume_delta = 10 - (time_left * time_left / 2.0)
    tick_tock_sfx.volume_db = volume_delta

func play_tick_tock_sfx() -> void:
    tick_tock_sfx.play()

func stop_tick_tock_sfx() -> void:
    tick_tock_sfx.stop()

func play_time_up_sfx() -> void:
    time_up_sfx.play()
