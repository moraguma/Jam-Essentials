extends Control
class_name OptionsInputChanger


const INPUT_CHANGE_BUTTON_SCENE = preload("res://addons/jam_essentials/scenes/ui/InputChangeButton.tscn")


@export var menu_base: Control
@export var actions: Array
@export var total_buttons: int = 2


@onready var label: Label = $Label
@onready var input_button_container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	add_to_group("localizable")
	localize()
	
	for idx in range(total_buttons):
		var new_button: InputChangeButton = INPUT_CHANGE_BUTTON_SCENE.instantiate()
		new_button.actions = actions
		new_button.idx = idx
		new_button.menu_base = menu_base
		input_button_container.add_child(new_button)
	
	custom_minimum_size[1] = label.size[1]


func localize() -> void:
	label.text = tr(actions[0])
