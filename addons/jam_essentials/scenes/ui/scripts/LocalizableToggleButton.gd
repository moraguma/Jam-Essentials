extends Control
class_name LocalizableToggleButton


@export var localization_code: String = ""


func _ready() -> void:
	$Label.text = tr(localization_code)
	add_to_group("localizable")
	
	custom_minimum_size[1] = max($Label.size[1], $CheckBox.size[1])
