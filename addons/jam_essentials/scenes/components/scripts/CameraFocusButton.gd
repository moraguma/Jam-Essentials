extends BaseButton
class_name CameraFocusButton


@export var aim_pos: Vector2


func _pressed():
	GlobalCamera.follow_pos(aim_pos)
