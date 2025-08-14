@tool
extends Control
class_name OptionsDropdownButton

signal select_item(parameter)


@export var title_localization_code: String: 
	set(val):
		title_localization_code = val
		
		if label != null:
			localize()
@export var localization_codes: Array[String]
@export var arguments: Array
@export var func_to_call: String
@export var call_binds: Array
@export var func_to_set: String
@export var set_binds: Array

@onready var option_button: OptionButton = $OptionButton
@onready var label: Label = $Label

func _ready() -> void:
	add_to_group("localizable")
	
	for localization_code in localization_codes:
		option_button.add_item(tr(localization_code))
	option_button.item_selected.connect(item_selected)
	
	localize()
	
	custom_minimum_size[1] = max(label.size[1], option_button.size[1])
	
	select_item.connect(Globals.create_callable(Save, func_to_call, call_binds))
	
	if func_to_set != "":
		select_by_val(Globals.create_callable(Save, func_to_set, set_binds).call())


func get_focusables() -> Array[Control]:
	return [option_button]


func item_selected(idx: int):
	select_item.emit(arguments[idx])


## Selects the correct option in the option_button based on the argument value
func select_by_val(val):
	var idx = arguments.find(val)
	if idx != -1:
		option_button.select(idx)


func localize() -> void:
	label.text = tr(title_localization_code)
	for i in range(len(localization_codes)):
		option_button.set_item_text(i, tr(localization_codes[i]))
