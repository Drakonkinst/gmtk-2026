extends Node

class_name UpgradeManager

signal attempt_upgrade_1(upgrade: Upgrade)
signal attempt_upgrade_2(upgrade: Upgrade)

# Connecting UI directly to manager without a signal cuz it's Day 3 and I don't got time for this
@export var upgrade_panel_1: UpgradePanel
@export var upgrade_panel_2: UpgradePanel
@export var upgrade_list_1: Array[Upgrade]
@export var upgrade_list_2: Array[Upgrade]

var unlocked_drawing_sets: Array[Drawing.DrawingSet] = []
var unlocked_tools: Dictionary = {}
var unlocked_colors := false
var unlocked_sizes := false

var upgrade_track_1 := 0
var upgrade_track_2 := 0

func _ready() -> void:
    upgrade_panel_1.set_upgrade(upgrade_list_1[upgrade_track_1])
    upgrade_panel_2.set_upgrade(upgrade_list_2[upgrade_track_2])
    unlocked_drawing_sets.push_back(Drawing.DrawingSet.SIMPLE)
    
    upgrade_panel_1.pressed.connect(_on_upgrade_panel_1_pressed)
    upgrade_panel_2.pressed.connect(_on_upgrade_panel_2_pressed)

    unlocked_tools[PlayerDrawing.Tool.BRUSH] = true
    unlocked_tools[PlayerDrawing.Tool.ERASER] = false
    unlocked_tools[PlayerDrawing.Tool.BUCKET] = false
    
    if Global.game.freedraw_mode:
        for i in range(len(upgrade_list_1)):
            unlock_upgrade_1()
        for i in range(len(upgrade_list_2)):
            unlock_upgrade_2()

func _process_upgrade(upgrade_id: String):
    if upgrade_id == "Eraser":
        unlocked_tools[PlayerDrawing.Tool.ERASER] = true
    elif upgrade_id == "Bucket":
        unlocked_tools[PlayerDrawing.Tool.BUCKET] = true
    elif upgrade_id == "Colors":
        unlocked_colors = true
    elif upgrade_id == "Sizes":
        unlocked_sizes = true
    elif upgrade_id == "Drawing1":
        unlocked_drawing_sets.push_back(Drawing.DrawingSet.ANIMALS)
    elif upgrade_id == "Drawing2":
        # unlocked_drawing_sets.push_back(Drawing.DrawingSet.ANIMALS)
        pass
    elif upgrade_id == "Drawing3":
        # unlocked_drawing_sets.push_back(Drawing.DrawingSet.ANIMALS)
        pass
    elif upgrade_id == "Drawing4":
        # unlocked_drawing_sets.push_back(Drawing.DrawingSet.ANIMALS)
        pass
        
    else:
        push_warning("Unknown upgrade ", upgrade_id)

func _on_upgrade_panel_1_pressed() -> void:
    if upgrade_track_1 >= len(upgrade_list_1):
        return
    attempt_upgrade_1.emit(upgrade_list_1[upgrade_track_1])
    
func _on_upgrade_panel_2_pressed() -> void:
    if upgrade_track_2 >= len(upgrade_list_1):
            return
    attempt_upgrade_2.emit(upgrade_list_1[upgrade_track_1])

func unlock_upgrade_1() -> void:
    if upgrade_track_1 >= len(upgrade_list_1):
        return
    _process_upgrade(upgrade_list_1[upgrade_track_1].id)
    upgrade_track_1 += 1
    if upgrade_track_1 < len(upgrade_list_1):
        upgrade_panel_1.set_upgrade(upgrade_list_1[upgrade_track_1])
    else:
        upgrade_panel_1.clear_upgrade()

func unlock_upgrade_2() -> void:
    if upgrade_track_2 >= len(upgrade_list_2):
        return
    _process_upgrade(upgrade_list_2[upgrade_track_2].id)
    upgrade_track_2 += 1
    if upgrade_track_2 < len(upgrade_list_2):
        upgrade_panel_2.set_upgrade(upgrade_list_2[upgrade_track_2])
    else:
        upgrade_panel_2.clear_upgrade()

func is_drawing_set_unlocked(drawingSet: Drawing.DrawingSet) -> bool:
    return unlocked_drawing_sets.has(drawingSet)
