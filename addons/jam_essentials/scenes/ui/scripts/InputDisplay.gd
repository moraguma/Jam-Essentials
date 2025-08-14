extends TextureRect
class_name InputDisplay

# + or - at the end to indicate direction. Neither means no direction
const AXIS_TO_STR = {
	JOY_AXIS_INVALID: "",
	JOY_AXIS_LEFT_X: "LX",
	JOY_AXIS_LEFT_Y: "LY",
	JOY_AXIS_RIGHT_X: "RX",
	JOY_AXIS_RIGHT_Y: "RY",
	JOY_AXIS_TRIGGER_LEFT: "LT",
	JOY_AXIS_TRIGGER_RIGHT: "RT"
}

const INVALID = "res://addons/jam_essentials/resources/kenney/Keyboard & Mouse/Default/keyboard_question.png"
const KEYCODE_PREFIX = "res://addons/jam_essentials/resources/kenney/Keyboard & Mouse/Default/keyboard_"
const KEYCODE_TO_TEX = {
	KEY_0: "0",
	KEY_1: "1",
	KEY_2: "2",
	KEY_3: "3",
	KEY_4: "4",
	KEY_5: "5",
	KEY_6: "6",
	KEY_7: "7",
	KEY_8: "8",
	KEY_9: "9",
	KEY_A: "a",
	KEY_B: "b",
	KEY_C: "c",
	KEY_D: "d",
	KEY_E: "e",
	KEY_F: "f",
	KEY_G: "g",
	KEY_H: "h",
	KEY_I: "i",
	KEY_J: "j",
	KEY_K: "k",
	KEY_L: "l",
	KEY_M: "m",
	KEY_N: "n",
	KEY_O: "o",
	KEY_P: "p",
	KEY_Q: "q",
	KEY_R: "r",
	KEY_S: "s",
	KEY_T: "t",
	KEY_U: "u",
	KEY_V: "v",
	KEY_W: "w",
	KEY_X: "x",
	KEY_Y: "y",
	KEY_Z: "z",
	KEY_ALT: "alt",
	KEY_APOSTROPHE: "apostrophe",
	KEY_DOWN: "arrow_down",
	KEY_LEFT: "arrow_left",
	KEY_RIGHT: "arrow_right",
	KEY_UP: "arrow_up",
	KEY_ASTERISK: "asterisk",
	KEY_BACKSPACE: "backspace_icon",
	KEY_BRACKETRIGHT: "bracket_close",
	KEY_BRACKETLEFT: "bracket_open",
	KEY_GREATER: "bracket_greater",
	KEY_LESS: "bracket_less",
	KEY_CAPSLOCK: "capslock_icon",
	KEY_COLON: "colon",
	KEY_COMMA: "comma",
	KEY_CTRL: "ctrl",
	KEY_DELETE: "delete",
	KEY_END: "end",
	KEY_ENTER: "return",
	KEY_EQUAL: "equals",
	KEY_ESCAPE: "escape",
	KEY_F1: "f1",
	KEY_F2: "f2",
	KEY_F3: "f3",
	KEY_F4: "f4",
	KEY_F5: "f5",
	KEY_F6: "f6",
	KEY_F7: "f7",
	KEY_F8: "f8",
	KEY_F9: "f9",
	KEY_F10: "f10",
	KEY_F11: "f11",
	KEY_F12: "f12",
	KEY_HOME: "home",
	KEY_INSERT: "insert",
	KEY_MINUS: "minus",
	KEY_NUMLOCK: "numlock",
	KEY_PAGEDOWN: "page_down",
	KEY_PAGEUP: "page_up",
	KEY_PERIOD: "period",
	KEY_PLUS: "plus",
	KEY_QUOTEDBL: "quote",
	KEY_SEMICOLON: "semicolon",
	KEY_SHIFT: "shift_icon",
	KEY_BACKSLASH: "slash_back",
	KEY_SLASH: "slash_forward",
	KEY_SPACE: "space_icon",
	KEY_TAB: "tab_icon_alternative",
	KEY_ASCIITILDE: "tilde",
}

const MOUSE_PREFIX = "res://addons/jam_essentials/resources/kenney/Keyboard & Mouse/Default/mouse_"
const MOUSE_TO_TEX = {
	MOUSE_BUTTON_LEFT: "left_outline",
	MOUSE_BUTTON_RIGHT: "right_outline",
	MOUSE_BUTTON_MIDDLE: "scroll_outline",
	MOUSE_BUTTON_WHEEL_DOWN: "scroll_down_outline",
	MOUSE_BUTTON_WHEEL_UP: "scroll_up_outline"
}

const SWITCH_PREFIX = "res://addons/jam_essentials/resources/kenney/Nintendo Switch/Default/switch_.png"
const SWITCH_TO_TEX = {
	JOY_BUTTON_A: "buttons_down_outline",
	JOY_BUTTON_B: "buttons_right_outline",
	JOY_BUTTON_X: "buttons_left_outline",
	JOY_BUTTON_Y: "buttons_up_outline",
	JOY_BUTTON_DPAD_UP: "up",
	JOY_BUTTON_DPAD_RIGHT: "right",
	JOY_BUTTON_DPAD_DOWN: "down",
	JOY_BUTTON_DPAD_LEFT: "left",
	JOY_BUTTON_BACK: "button_minus",
	JOY_BUTTON_START: "button_plus",
	JOY_BUTTON_LEFT_SHOULDER: "button_l",
	JOY_BUTTON_RIGHT_SHOULDER: "button_r",
	JOY_BUTTON_LEFT_STICK: "stick_l_press",
	JOY_BUTTON_RIGHT_STICK: "stick_r_press",
	"LX-": "stick_l_left",
	"LX+": "stick_l_right",
	"LY-": "stick_l_up",
	"LY+": "stick_l_down",
	"RX-": "stick_r_left",
	"RX+": "stick_r_right", 
	"RY-": "stick_r_up",
	"RY+": "stick_r_down",
	"LT+": "button_zl",
	"RT+": "button_zr"
}

const XBOX_PREFIX = "res://addons/jam_essentials/resources/kenney/Xbox Series/Default/xbox_"
const XBOX_TO_TEX = {
	JOY_BUTTON_A: "button_a",
	JOY_BUTTON_B: "button_b",
	JOY_BUTTON_X: "button_x",
	JOY_BUTTON_Y: "button_y",
	JOY_BUTTON_DPAD_UP: "dpad_up_outline",
	JOY_BUTTON_DPAD_RIGHT: "dpad_right_outline",
	JOY_BUTTON_DPAD_DOWN: "dpad_down_outline",
	JOY_BUTTON_DPAD_LEFT: "dpad_left_outline",
	JOY_BUTTON_BACK: "button_view",
	JOY_BUTTON_START: "button_menu",
	JOY_BUTTON_LEFT_SHOULDER: "lb",
	JOY_BUTTON_RIGHT_SHOULDER: "rb",
	JOY_BUTTON_LEFT_STICK: "stick_l_press",
	JOY_BUTTON_RIGHT_STICK: "stick_r_press",
	"LX-": "stick_l_left",
	"LX+": "stick_l_right",
	"LY-": "stick_l_up",
	"LY+": "stick_l_down",
	"RX-": "stick_r_left",
	"RX+": "stick_r_right", 
	"RY-": "stick_r_up",
	"RY+": "stick_r_down",
	"LT+": "lt",
	"RT+": "rt"
}

const PLAYSTATION_PREFIX = "res://addons/jam_essentials/resources/kenney/PlayStation Series/Default/playstation_"
const PLAYSTATION_TO_TEX = {
	JOY_BUTTON_A: "button_cross",
	JOY_BUTTON_B: "button_circle",
	JOY_BUTTON_X: "button_square",
	JOY_BUTTON_Y: "button_triangle",
	JOY_BUTTON_DPAD_UP: "dpad_up_outline",
	JOY_BUTTON_DPAD_RIGHT: "dpad_right_outline",
	JOY_BUTTON_DPAD_DOWN: "dpad_down_outline",
	JOY_BUTTON_DPAD_LEFT: "dpad_left_outline",
	JOY_BUTTON_BACK: "button_share",
	JOY_BUTTON_START: "button_options",
	JOY_BUTTON_LEFT_SHOULDER: "trigger_l1",
	JOY_BUTTON_RIGHT_SHOULDER: "trigger_r1",
	JOY_BUTTON_LEFT_STICK: "stick_l_press",
	JOY_BUTTON_RIGHT_STICK: "stick_r_press",
	"LX-": "stick_l_left",
	"LX+": "stick_l_right",
	"LY-": "stick_l_up",
	"LY+": "stick_l_down",
	"RX-": "stick_r_left",
	"RX+": "stick_r_right", 
	"RY-": "stick_r_up",
	"RY+": "stick_r_down",
	"LT+": "trigger_l2_alternative",
	"RT+": "trigger_r2_alternative"
}
const FORMAT = ".png"


@export var action: String
@export var idx: int = 0
var current_tex_path


func _ready():
	InputHelper.device_changed.connect(update_display)
	InputHelper.joypad_input_changed.connect(update_action)
	InputHelper.keyboard_input_changed.connect(update_action)
	
	update_display(InputHelper.device, InputHelper.device_index)


func update_action(changed_action, input):
	if action == changed_action:
		update_display(InputHelper.device, InputHelper.device_index)


func update_display(device: String, device_idx):
	var input_events: Array[InputEvent] = InputHelper.get_keyboard_inputs_for_action(action) if device == InputHelper.DEVICE_KEYBOARD else InputHelper.get_joypad_inputs_for_action(action)
	var input_event = null if len(input_events) < idx + 1 else input_events[idx]
	
	if input_event is InputEventKey:
		try_load_from_dict(input_event.keycode, KEYCODE_TO_TEX, KEYCODE_PREFIX)
	elif input_event is InputEventMouseButton:
		try_load_from_dict(input_event.button_index, MOUSE_TO_TEX, MOUSE_PREFIX)
	elif input_event is InputEventJoypadButton:
		try_load_from_dict(input_event.button_index, get_device_dict(device), get_device_prefix(device))
	elif input_event is InputEventJoypadMotion:
		var motion_str = AXIS_TO_STR[input_event.axis]
		if input_event.axis_value != 0.0:
			motion_str += "-" if input_event.axis_value < 0 else "+"
		
		try_load_from_dict(motion_str, get_device_dict(device), get_device_prefix(device))
	else:
		load_invalid_tex()


func get_device_prefix(device: String):
	match device:
		InputHelper.DEVICE_SWITCH_CONTROLLER:
			return SWITCH_PREFIX
		InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
			return PLAYSTATION_PREFIX
		_:
			return XBOX_PREFIX


func get_device_dict(device: String):
	match device:
		InputHelper.DEVICE_SWITCH_CONTROLLER:
			return SWITCH_TO_TEX
		InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
			return PLAYSTATION_TO_TEX
		_:
			return XBOX_TO_TEX


func try_load_from_dict(x, dict: Dictionary, prefix: String):
	if x in dict:
		current_tex_path = prefix + dict[x] + FORMAT
		load_tex()
	else:
		load_invalid_tex()


func load_tex():
	if not ResourceLoader.exists(current_tex_path):
		push_warning("Tried to access invalid input image @ " + current_tex_path)
		load_invalid_tex()
		return
	
	var initial_tex_path = current_tex_path
	
	ResourceLoader.load_threaded_request(initial_tex_path)
	
	await get_tree().process_frame
	while initial_tex_path == current_tex_path:
		var status = ResourceLoader.load_threaded_get_status(initial_tex_path)
		if status in [ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED]:
			load_invalid_tex()
			break
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			texture = ResourceLoader.load_threaded_get(initial_tex_path)
			break
		
		await get_tree().process_frame


func load_invalid_tex():
	current_tex_path = INVALID
	load_tex()
