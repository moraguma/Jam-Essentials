extends Label
class_name LocalizableLabel


@export var localization_code: String = ""


func _ready() -> void:
	add_to_group("localizable")
	
	localize()


func localize() -> void:
	text = tr(localization_code)
