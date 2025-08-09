extends Button
class_name LocalizableButton


@export var localization_code: String = ""


func _ready() -> void:
	text = tr(localization_code)
	add_to_group("localizable")
