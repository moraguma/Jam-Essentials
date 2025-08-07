extends Label
class_name LocalizableLabel


@export var localization_code: String = ""


func _ready() -> void:
	text = tr(localization_code)
	add_to_group("localizable")
