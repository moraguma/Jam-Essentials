extends BaseButton
class_name CameraFocusButton


@export var aim_pos: Vector2
@export var new_focus: Control


func _pressed():
	GlobalCamera.follow_pos(aim_pos)
	
	if new_focus:
		new_focus.grab_focus()
