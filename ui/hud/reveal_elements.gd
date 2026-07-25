extends Control

class_name RevealElements

@export var on_color_reveal: Array[Control]
@export var on_tools_reveal: Array[Control]
@export var on_sizes_reveal: Array[Control]
@export var on_bucket_reveal: Array[Control]

func _ready() -> void:
    _hide_all(on_color_reveal)
    _hide_all(on_tools_reveal)
    _hide_all(on_sizes_reveal)
    _hide_all(on_bucket_reveal)

func on_upgrade_unlocked(upgrade: Upgrade) -> void:
    if upgrade.id == "Eraser":
        _reveal_all(on_tools_reveal)
    if upgrade.id == "Bucket":
        _reveal_all(on_bucket_reveal)
    if upgrade.id == "Colors":
        _reveal_all(on_color_reveal)
    if upgrade.id == "Sizes":
        _reveal_all(on_sizes_reveal)

func _hide_all(list: Array[Control]):
    for obj in list:
        obj.hide()

func _reveal_all(list: Array[Control]):
    for obj in list:
        obj.show()
