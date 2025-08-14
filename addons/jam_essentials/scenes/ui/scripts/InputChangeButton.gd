extends Button
class_name InputChangeButton


const INPUT_CHANGE_POPUP_SCENE = preload("res://addons/jam_essentials/scenes/ui/InputChangePopup.tscn")


## Actions this button will be associated with. The first action will be used
## to choose the instructions to be shown, but all associated actions will be
## changed if this button is changed
@export var actions: Array
@export var idx: int
@export var menu_base: Control


var has_mouse: bool = false


@onready var input_display: InputDisplay = $InputDisplay
@onready var base_color: Color = input_display.modulate
@onready var focus_color: Color = theme.get_color("font_hover_color", "Button")


func _ready() -> void:
	focus_entered.connect(_focus_entered)
	focus_exited.connect(_focus_exited)
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	
	setup_input_display()


func _process(delta: float) -> void:
	custom_minimum_size = input_display.size


## Called on startup to display the correct action
func setup_input_display() -> void:
	input_display.action = actions[0]
	input_display.idx = idx
	input_display.update_display(InputHelper.device, InputHelper.device_index)


func _pressed():
	var new_popup: InputChangePopup = INPUT_CHANGE_POPUP_SCENE.instantiate()
	new_popup.pressed_button.connect(assign_event)
	menu_base.add_child(new_popup)
	new_popup.activate(actions[0])
	
	release_focus()


func assign_event(event):
	grab_focus()
	
	if event != null:
		for i in range(len(actions)):
			var action = actions[i]
			if InputHelper.device == InputHelper.DEVICE_KEYBOARD:
				InputHelper.replace_keyboard_input_at_index(action, idx, event, i == 0)
			else:
				InputHelper.replace_joypad_input_at_index(action, idx, event, i == 0)


func _focus_entered() -> void:
	input_display.modulate = focus_color


func _focus_exited() -> void:
	input_display.modulate = focus_color if has_mouse else base_color


func _mouse_entered() -> void:
	has_mouse = true
	input_display.modulate = focus_color


func _mouse_exited() -> void:
	has_mouse = false
	input_display.modulate = focus_color if has_focus() else base_color
