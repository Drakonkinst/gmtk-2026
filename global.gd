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
	# if config.has_section_key("category", "setting") -> config.get_value("category", "setting")
	config.save(CONFIG_PATH)   

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
