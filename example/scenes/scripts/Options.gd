extends Control
class_name Options


var active = false
var past_focus = null


@onready var tabs_container: TabsContainer = $TabsContainer


func _ready() -> void:
	tabs_container.block()
	hide()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if active:
			tabs_container.block()
			get_tree().paused = false
			hide()
			if past_focus:
				past_focus.grab_focus()
		else:
			tabs_container.unblock()
			get_tree().paused = true
			show()
			past_focus = get_viewport().gui_get_focus_owner()
			tabs_container.go_to_tab(0, true)
		active = !active
