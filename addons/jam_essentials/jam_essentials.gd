@tool
extends EditorPlugin


const AUTOLOADS = {
	"SceneManager": "res://addons/jam_essentials/scenes/autoloads/SceneManager.tscn",
	"GlobalCamera": "res://addons/jam_essentials/scenes/autoloads/GlobalCamera.tscn",
	"SoundController": "res://addons/jam_essentials/scenes/autoloads/SoundController.tscn",
	"Globals": "res://addons/jam_essentials/scenes/autoloads/Globals.tscn"
}


func _enter_tree():
	for autoload_name in AUTOLOADS:
		add_autoload_singleton(autoload_name, AUTOLOADS[autoload_name])


func _exit_tree():
	for autoload_name in AUTOLOADS:
		remove_autoload_singleton(autoload_name)
