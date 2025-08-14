extends Node


const MASTER_BUS = 0
const MUSIC_BUS = 1
const SFX_BUS = 2
const BUS_TO_STRING = {
	MASTER_BUS: "Master",
	MUSIC_BUS: "Music",
	SFX_BUS: "SFX"
}


## If not empty, loads this default save once the game starts
@export var default_save: String = "save"


func _ready() -> void:
	if default_save != "":
		Save.load_game(default_save)
	Save.load_options()


## If the given check is true, pushes a warning message and returns true.
## Otherwise, returns false
func check_and_error(check: bool, message: String):
	if check:
		push_error(message)
		return true
	return false


## Time dependent lerp
func tlerp(a, b, weight: float, delta: float):
	return lerp(a, b, exp(-weight * delta))
