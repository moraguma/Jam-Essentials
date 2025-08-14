@tool
extends Control
class_name OptionsToggleButton


@export var localization_code: String = "":
	set(val):
		localization_code = val
		
		if label != null:
			localize()
@export var func_to_call: String
@export var call_binds: Array
@export var func_to_set: String
@export var set_binds: Array


@onready var label = $Label
@onready var check_box: CheckBox = $CheckBox


func _ready() -> void:
	add_to_group("localizable")
	
	localize()
	
	custom_minimum_size[1] = max($Label.size[1], $CheckBox.size[1])
	
	check_box.toggled.connect(Globals.create_callable(Save, func_to_call, call_binds))
	
	if func_to_set != "":
		check_box.set_pressed_no_signal(Globals.create_callable(Save, func_to_set, set_binds).call())


func get_focusables() -> Array[Control]:
	return [check_box]


func localize() -> void:
	label.text = tr(localization_code)
