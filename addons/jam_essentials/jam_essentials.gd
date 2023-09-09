@tool
extends EditorPlugin


const AUTOLOADS = {"SceneManager": "res://addons/scenes/SceneManager.tscn"}


func _enter_tree():
	for autoload_name in AUTOLOADS:
		add_autoload_singleton(autoload_name, AUTOLOADS[autoload_name])


func _exit_tree():
	for autoload_name in AUTOLOADS:
		remove_autoload_singleton(autoload_name)
