extends Control
class_name LocalizableSlider


@export var localization_code: String


func _ready() -> void:
	add_to_group("localizable")
	
	$Label.text = tr(localization_code)
	
	custom_minimum_size[1] = max($Label.size[1], $HSlider.size[1])
