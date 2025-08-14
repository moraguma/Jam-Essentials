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
var menu_focusables: Array[Array] = []
var last_focus: Control = null


@onready var menu_container = $ScrollContainer/VBoxContainer


func _ready() -> void:
	# Create focusables
	for object in menu_container.get_children():
		var new_focusables = object.get_focusables()
		if len(new_focusables) > 0:
			add_focusables(new_focusables)
	
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
			
			# Next and previous
			menu_focusables[i][j].focus_next = menu_focusables[i][j].get_path_to(menu_focusables[i][j])
			menu_focusables[i][j].focus_previous = menu_focusables[i][j].get_path_to(menu_focusables[i][j])

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
		focusable.focus_entered.connect(update_last_focus.bind(focusable))
	menu_focusables.append(focusables)


## Called when an object in this menu is focused on
func update_last_focus(f: Control) -> void:
	last_focus = f


## Resets last focus
func reset_focus() -> void:
	last_focus = null
