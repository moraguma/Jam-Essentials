extends Button


@export var transition_path: String


func _pressed():
	SceneManager.goto_scene(transition_path)
