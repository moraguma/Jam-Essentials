extends LocalizableButton
class_name OptionsButton


@export var func_to_call: String
@export var call_binds: Array


func _ready() -> void:
	super()
	
	pressed.connect(Globals.create_callable(Save, func_to_call, call_binds))


func get_focusables() -> Array[Control]:
	return [self]
