extends Control
class_name LocalizableDropdownButton


signal select_item(parameter)


@export var title_localization_code: String
@export var localization_codes: Array
@export var arguments: Array


func _ready() -> void:
	add_to_group("localizable")
	
	var option_button: OptionButton = $OptionButton
	
	$Label.text = tr(title_localization_code)
	for localization_code in localization_codes:
		option_button.add_item(tr(localization_code))
	option_button.item_selected.connect(item_selected)
	
	custom_minimum_size[1] = max($Label.size[1], $OptionButton.size[1])


func item_selected(idx: int):
	select_item.emit(arguments[idx])
