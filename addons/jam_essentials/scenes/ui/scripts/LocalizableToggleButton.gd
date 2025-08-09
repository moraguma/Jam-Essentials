extends Control
class_name LocalizableToggleButton


@export var localization_code: String = ""


func _ready() -> void:
	$Label.text = tr(localization_code)
	add_to_group("localizable")
