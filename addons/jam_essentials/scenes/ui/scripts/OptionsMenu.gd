extends Control
class_name OptionsMenu

const TAB_SCENE = preload("res://addons/jam_essentials/scenes/ui/Tab.tscn")
const MENU_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsMenu.tscn")

const TITLE_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsTitle.tscn")
const BUTTON_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsButton.tscn")
const TOGGLE_BUTTON_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsToggleButton.tscn")
const DROPDOWN_BUTTON_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsDropdownButton.tscn")
const SLIDER_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsSlider.tscn")
const INPUT_CHANGER_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsInputChanger.tscn")


@export_category("Menus")

@export var menu_base: Control

## Array of menus represented as arrays. Each menu is composed as a list of
## objects, each represented by a dictionary. The following object types are
## supported:
##
## {
##     "type": "title",
##     "localization_code": "code"
## }
##
## {
##     "type": "button",
##     "localization_code": "code",
##     "func_to_call": ""
## }
##
## {
##     "type": "toggle_button",
##     "localization_code": "code",
##     "func_to_call": "",
##     "func_to_set": ""
## }
##
## {
##     "type": "dropdown_button",
##     "title_localization_code": "code",
##     "localization_codes": ["code1", "code2"],
##     "arguments": [arg1, arg2]
##     "func_to_call": "",
##     "func_to_set": ""
## }
##
## {
##     "type": "slider",
##     "localization_code": "code",
##     "notches": (optional) 2 to +inf
##     "func_to_call": "",
##     "func_to_set": ""
## }
##
## {
##     "type": "input_changer",
##     "actions": ["action_1", ["action_2", "action_2_alt"], "action_3"]
##     "inputs_per_action": 1 to 4
## }
@export var menu_specifications: Array[Dictionary] = []
@export var match_size: Control = null

var menu_focusables: Array[Array] = []
var last_focus: Control = null


@onready var menu_container = $ScrollContainer/VBoxContainer


func _ready() -> void:
	# Create menu
	if match_size != null:
		custom_minimum_size = match_size.size
	
	for object in menu_specifications:
		match object["type"]:
			"title":
				var new_title = TITLE_SCENE.instantiate()
				new_title.localization_code = object["localization_code"]
				menu_container.add_child(new_title)
			"button":
				var new_button = BUTTON_SCENE.instantiate()
				new_button.localization_code = object["localization_code"]
				new_button.pressed.connect(Callable(self, object["func_to_call"]))
				menu_container.add_child(new_button)
				
				add_focusables([new_button])
			"toggle_button":
				var new_toggle_button = TOGGLE_BUTTON_SCENE.instantiate()
				new_toggle_button.localization_code = object["localization_code"]
				new_toggle_button.get_node("CheckBox").toggled.connect(Callable(self, object["func_to_call"]))
				if "func_to_set" in object:
					new_toggle_button.get_node("CheckBox").set_pressed_no_signal(call(object["func_to_set"]))
				menu_container.add_child(new_toggle_button)
				
				add_focusables([new_toggle_button.get_node("CheckBox")])
			"dropdown_button":
				var new_dropdown_button = DROPDOWN_BUTTON_SCENE.instantiate()
				new_dropdown_button.title_localization_code = object["title_localization_code"]
				new_dropdown_button.localization_codes = object["localization_codes"]
				new_dropdown_button.arguments = object["arguments"]
				new_dropdown_button.select_item.connect(Callable(self, object["func_to_call"]))
				if "func_to_set" in object:
					new_dropdown_button.get_node("OptionButton").select(call(object["func_to_set"]))
				menu_container.add_child(new_dropdown_button)
				
				add_focusables([new_dropdown_button.get_node("OptionButton")])
			"slider":
				var new_slider = SLIDER_SCENE.instantiate()
				var h_slider = new_slider.get_node("HSlider")
				
				new_slider.localization_code = object["localization_code"]
				h_slider.value_changed.connect(Callable(self, object["func_to_call"]))
				if "notches" in object:
					h_slider.ticks_on_borders = true
					h_slider.tick_count = object["notches"]
					h_slider.step = 1.0 / (float(object["notches"]) - 1)
				if "func_to_set" in object:
					h_slider.set_value_no_signal(call(object["func_to_set"]))
				menu_container.add_child(new_slider)
				
				add_focusables([h_slider])
			"input_changer":
				for action_arr in object["actions"]:
					if action_arr is String:
						action_arr = [action_arr]
					
					var new_input_changer: OptionsInputChanger = INPUT_CHANGER_SCENE.instantiate()
					new_input_changer.menu_base = menu_base
					new_input_changer.actions = action_arr
					new_input_changer.total_buttons = object["inputs_per_action"]
					menu_container.add_child(new_input_changer)
					
					add_focusables(new_input_changer.input_button_container.get_children())
	
	# Create neighbor connections
	for i in range(len(menu_focusables)):
		for j in range(len(menu_focusables[i])):
			# Top and bottom
			var top = menu_focusables[i - 1][min(len(menu_focusables[i - 1]) - 1, j)] if i > 0 else menu_focusables[i][j]
			menu_focusables[i][j].focus_neighbor_top = menu_focusables[i][j].get_path_to(top)
			
			var bottom = menu_focusables[i + 1][min(len(menu_focusables[i + 1]) - 1, j)] if i < len(menu_focusables) - 1 else menu_focusables[i][j]
			menu_focusables[i][j].focus_neighbor_bottom = menu_focusables[i][j].get_path_to(bottom)
			
			# Left and right
			var left = menu_focusables[i][j - 1] if j > 0 else menu_focusables[i][j]
			menu_focusables[i][j].focus_neighbor_left = menu_focusables[i][j].get_path_to(left)
			
			var right = menu_focusables[i][j + 1] if j < len(menu_focusables[i]) - 1 else menu_focusables[i][j]
			menu_focusables[i][j].focus_neighbor_right = menu_focusables[i][j].get_path_to(right)


## Should be called when this menu shows on screen
func activate() -> void:
	if last_focus != null:
		last_focus.grab_focus()
	elif len(menu_focusables) > 0:
		menu_focusables[0][0].grab_focus()


## Adds an array of focusables to menu_focusables, also adding signals to
## control player mouse position
func add_focusables(focusables: Array) -> void:
	for focusable: Control in focusables:
		focusable.focus_entered.connect(update_last_focus)
	menu_focusables.append(focusables)


## Called when an object in this menu is focused on
func update_last_focus(f: Control) -> void:
	last_focus = f


## Resets last focus
func reset_focus() -> void:
	last_focus = null


func toggle_test(t):
	print(t)
