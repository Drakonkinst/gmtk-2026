extends Button

class_name UpgradePanel

@export var text_label: RichTextLabel
@export var cost_label: RichTextLabel
var current_upgrade: Upgrade
var locked := false

func set_upgrade(upgrade: Upgrade):
    print("Setting upgrade to ", upgrade.id)
    current_upgrade = upgrade
    text_label.text = current_upgrade.text
    cost_label.text = "Cost: " + str(current_upgrade.cost) + "s"

func clear_upgrade():
    text_label.text = "Fully Unlocked"
    cost_label.text = ""
    locked = true

func _process(delta: float) -> void:
    if not current_upgrade:
        return
    var seconds_left := Global.game.countdown_manager.get_seconds_left()
    disabled = locked or seconds_left < current_upgrade.cost
    cost_label.add_theme_color_override("default_color", Color.RED if disabled else Color.GREEN)
        
