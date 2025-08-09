extends Control
class_name Options


const TAB_SCENE = preload("res://addons/jam_essentials/scenes/ui/Tab.tscn")
const MENU_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsMenu.tscn")

const TITLE_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsTitle.tscn")
const BUTTON_SCENE = preload("res://addons/jam_essentials/scenes/ui/OptionsButton.tscn")

const TAB_TLERP_WEIGHT = 100.0
const MENU_TLERP_WEIGHT = 100.0


@export_category("Tabs")
## Given in % of tab container, it is how much an active tab should occupy of
## the screen horizontaly
@export var active_tab_spacing = 0.8
@export var tab_left_input = "ui_focus_prev"
@export var tab_right_input = "ui_focus_next"
var inactive_tab_spacing = 0.0
@export var tab_names: Array[String]
@export var tab_icons: Array[Texture2D]

@export_category("Menus")
## Array of menus represented as arrays. Each menu is composed as a list of
## objects, each represented by a dictionary. The following object types are
## supported:
##
## {
##     "type": "button",
##     "localization_code": "code",
##     "func_to_call": ""
## }
##
## {
##     "type": "title",
##     "localization_code": "code"
## }
##
## {
##     "type": "check_button",
##     "localization_code": "code",
##     "func_to_call": ""
## }
##
## {
##     "type": "dropdown_button",
##     "localization_codes": ["code1", "code2"],
##     "option_arguments": [arg1, arg2]
##     "func_to_call": ""
## }
##
## {
##     "type": "slider",
##     "localization_code": "code",
##     "notches": -1 to +inf
##     "func_to_call": ""
## }
@export var menu_specifications: Array[Array] = []
var menus: Array[Control] = []
var menu_focusables: Array[Array] = []


var tabs: Array[Tab]
var tab_progress: float = 1.0
var current_tab_pos: int = 0
var past_tab_pos: int = 0


@onready var tab_container: Control = $Tabs
@onready var main_panel: Panel = $MainPanel
@onready var menu_container: HBoxContainer = $MainPanel/Menus


func _ready() -> void:
	# Create tabs
	for i in range(len(tab_names)):
		var new_tab: Tab = TAB_SCENE.instantiate()
		new_tab.size[1] = tab_container.size[1]
		tab_container.add_child(new_tab)
		new_tab.initialize(tab_names[i], tab_icons[i])
		new_tab.clicked.connect(go_to_tab.bind(i))
		
		if i == current_tab_pos:
			new_tab.select()
		else:
			new_tab.deselect()
		
		tabs.append(new_tab)
	if len(tabs) == 1:
		active_tab_spacing = 1.0
	inactive_tab_spacing = (1.0 - active_tab_spacing) / (len(tab_names) - 1) if len(tab_names) > 1 else 0.0
	_tab_process(0.0)
	
	# Create menus
	for i in range(len(tabs)):
		var new_menu = MENU_SCENE.instantiate()
		new_menu.custom_minimum_size = main_panel.size
		menu_container.add_child(new_menu)
		menus.append(new_menu)
		
		var new_menu_container = new_menu.get_node("ScrollContainer/VBoxContainer")
		menu_focusables.append([])
		for object in menu_specifications[i]:
			match object["type"]:
				"title":
					var new_title = TITLE_SCENE.instantiate()
					new_title.localization_code = object["localization_code"]
					new_menu_container.add_child(new_title)
				"button":
					var new_button = BUTTON_SCENE.instantiate()
					new_button.localization_code = object["localization_code"]
					new_button.pressed.connect(Callable(self, object["func_to_call"]))
					new_menu_container.add_child(new_button)
					
					menu_focusables[i].append(new_button)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(tab_left_input):
		var pos = current_tab_pos - 1
		if pos < 0:
			pos = len(tabs) - 1
		go_to_tab(pos)
	elif Input.is_action_just_pressed(tab_right_input):
		var pos = current_tab_pos + 1
		if pos >= len(tabs):
			pos = 0
		go_to_tab(pos)


func _process(delta: float) -> void:
	_tab_process(delta)


## Processes tab size, making selected tab bigger
func _tab_process(delta: float) -> void:
	tab_progress = Globals.tlerp(tab_progress, 1.0, TAB_TLERP_WEIGHT, delta)
	var total_spacing = 0.0
	for i in range(len(tabs)):
		var spacing
		if i == current_tab_pos:
			spacing = lerp(inactive_tab_spacing, active_tab_spacing, tab_progress)
		elif i == past_tab_pos:
			spacing = lerp(active_tab_spacing, inactive_tab_spacing, tab_progress)
		else:
			spacing = inactive_tab_spacing
		tabs[i].size[0] = spacing * tab_container.size[0]
		
		tabs[i].position[0] = total_spacing * tab_container.size[0]
		total_spacing += spacing
	
	menu_container.position[0] = Globals.tlerp(menu_container.position[0], -current_tab_pos * main_panel.size[0], MENU_TLERP_WEIGHT, delta)


## Sets the given tab as current. If skip_animation is true, instantly 
## transitions to the next one
func go_to_tab(pos: int, skip_animation: bool=false) -> void:
	if pos == current_tab_pos:
		skip_animation = true
	
	tabs[current_tab_pos].deselect()
	
	past_tab_pos = current_tab_pos
	current_tab_pos = pos
	
	tabs[current_tab_pos].select()
	tab_progress = 1.0 if skip_animation else 0.0


func test():
	print("hi")
