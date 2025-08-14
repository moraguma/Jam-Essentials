@tool
extends Control
class_name LocalizableSlider


@export var localization_code: String:
	set(val):
		localization_code = val
		
		if label != null:
			localize()
@export var func_to_call: String
@export var call_binds: Array
@export var func_to_set: String
@export var set_binds: Array
@export_range(-1, 10, 1) var notches: int = -1


@onready var h_slider: HSlider = $HSlider
@onready var label: Label = $Label


func _ready() -> void:
	add_to_group("localizable")
	localize()
	
	h_slider.value_changed.connect(Globals.create_callable(Save, func_to_call, call_binds))
	if notches > -1:
		h_slider.ticks_on_borders = true
		h_slider.tick_count = notches
		h_slider.step = 1.0 / (float(notches) - 1)
	
	if func_to_set != "":
		h_slider.set_value_no_signal(Globals.create_callable(Save, func_to_set, set_binds).call())
	
	custom_minimum_size[1] = max(label.size[1], h_slider.size[1])


func localize() -> void:
	label.text = tr(localization_code)
	custom_minimum_size[1] = max(label.size[1], h_slider.size[1])


func get_focusables() -> Array[Control]:
	return [h_slider]
