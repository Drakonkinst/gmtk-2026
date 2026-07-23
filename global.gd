extends Node

const CONFIG_PATH := "user://settings.cfg"

var game: Game = null
var main: Main = null

var config := ConfigFile.new()
var music := AudioServer.get_bus_index("Music")
var ui := AudioServer.get_bus_index("UI")
var environment := AudioServer.get_bus_index("Environment")
var audio: AudioManager

func _ready() -> void:
    _load_config()
    print("music=", music, ", ui=", ui, ", environment=", environment)

func _load_config() -> void:
    var err := config.load(CONFIG_PATH)
    if err != OK:
        return
    if config.has_section_key("audio", "music"):
            set_music_volume(config.get_value("audio", "music"), false)
    if config.has_section_key("audio", "ui"):
        set_ui_volume(config.get_value("audio", "ui"), false)
    if config.has_section_key("audio", "environment"):
        set_environment_volume(config.get_value("audio", "environment"), false)
    config.save(CONFIG_PATH)   

func set_music_volume(value: float, save: bool = true) -> void:
    AudioServer.set_bus_volume_db(music, linear_to_db(value))
    if save:
        config.set_value("audio", "music", value)
        config.save(CONFIG_PATH)

func set_ui_volume(value: float, save: bool = true) -> void:
    AudioServer.set_bus_volume_db(ui, linear_to_db(value))
    if save:
        config.set_value("audio", "ui", value)
        config.save(CONFIG_PATH)

func set_environment_volume(value: float, save: bool = true) -> void:
    AudioServer.set_bus_volume_db(environment, linear_to_db(value))
    if save:
        config.set_value("audio", "environment", value)
        config.save(CONFIG_PATH)

func get_music_volume() -> float:
    return db_to_linear(AudioServer.get_bus_volume_db(music))

func get_environment_volume() -> float:
    return db_to_linear(AudioServer.get_bus_volume_db(environment))

func get_ui_volume() -> float:
    return db_to_linear(AudioServer.get_bus_volume_db(ui))
