extends Control
class_name InputChangePopup


signal pressed_button(event: InputEvent)


const TIME = 11
const DEADZONE = 0.5


var active = true


@onready var timer: Timer = $Timer
@onready var instructions: Label = $Panel/Instructions
@onready var time_left: Label = $Panel/TimeLeft


func _ready() -> void:
	timer.timeout.connect(deactivate.bind(null))


func _input(event: InputEvent) -> void:
	if active:
		if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
			deactivate(event)
		elif event is InputEventJoypadMotion:
			if abs(event.axis_value) > DEADZONE and not event.axis in [JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y, JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y]:
				event.axis_value = 1.0 if event.axis_value > 0.0 else -1.0
				deactivate(event)


func _process(delta: float) -> void:
	if active:
		time_left.text = tr("Cancelling in {time_left}s...").format({"time_left": "%d" % [timer.time_left]})


## Should be called when this is meant to appear on screen. Sets up the text
func activate(action_name) -> void:
	get_tree().call_group("ui_blockable", "block")
	
	instructions.text = tr("Assign a button to {action}").format({"action": action_name})
	
	active = true
	timer.start(TIME)


## Called upon timeout or input selection. Frees this popup after emitting the
## pressed_button signal
func deactivate(event) -> void:
	get_tree().call_group("ui_blockable", "unblock")
	
	active = false
	timer.stop()
	
	await get_tree().physics_frame
	
	pressed_button.emit(event)
	queue_free()
