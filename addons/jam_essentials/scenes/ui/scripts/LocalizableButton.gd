extends Button
class_name LocalizableButton


@export var localization_code: String = ""


func _ready() -> void:
	add_to_group("localizable")
	
	localize()


func localize() -> void:
	text = tr(localization_code)
