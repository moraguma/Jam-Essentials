extends Node

const BASE_OPTIONS_PATH = "res://addons/jam_essentials/resources/data/options.json"
const OPTIONS_PATH = "user://options.json"

const BASE_SAVE_PATH = "res://addons/jam_essentials/resources/data/options.json"
const SAVE_PATH = "user://saves/"
const SAVE_EXTENSION = ".json"

var options: Dictionary
var save: Dictionary
var save_name: String = ""
var last_time: int
var time_paused: bool = false


func _ready():
	load_options()


#region UTIL
## Return the data specified by the array in file. If the array is, for instance, 
## ["position", "current_room"], will return save["position"]["current_room"].
## If the specified path doesn't exist, returns null
func get_data(data, path: Array):
	var result = data
	for p in path:
		if not p in result:
			return null
		result = result[p]
	return result


## Sets val as the value stored in the specified file. Saving it to the
## file system requires calling save_game()
func set_data(data, path: Array, val):
	var result = data
	for i in range(0, len(path) - 1):
		if not path[i] in result:
			result[path[i]] = {}
		result = result[path[i]]
	result[path[-1]] = val


## Erases the entry given by path in the specified file. Saving it to the file
## system requires calling save_game()
func erase_data(data, path: Array):
	var result = data
	for i in range(0, len(path) - 1):
		if not path[i] in result:
			result[path[i]] = {}
		result = result[path[i]]
	result.erase(path[-1])


## Sets multiple values for multiple data paths in file. For each i, will set 
## path_prefix > path[i] to vals[i]
func set_datas(data, paths: Array, vals: Array, path_prefix: Array=[]):
	var base = data
	for p in path_prefix:
		base = base[p]
	
	for i in range(len(paths)):
		var result = base
		for j in range(0, len(paths[i]) - 1):
			result = result[paths[i][j]]
		result[paths[i][-1]] = vals[i]
#endregion

#region SAVE
# ------------------------------------------------------------------------------
# SAVE
# ------------------------------------------------------------------------------


## Checks save version and updates it depending on version number
func validate_save() -> void:
	#if save["version"] < 0.3:
	#	save["version"] = 0.3
	#and so on and so forth
	
	pass


## Saves the current state of save file to file system
func save_game() -> void:
	update_time()
	
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_PATH)
	
	var save_file = FileAccess.open(SAVE_PATH + save_name + SAVE_EXTENSION, FileAccess.WRITE)
	var json_string = JSON.stringify(save, "\t")
	save_file.store_line(json_string)


## Loads specified save from file system, creating a new one if it doesn't exist
func load_game(new_save_name):
	save_name = new_save_name

	var save_file
	if not FileAccess.file_exists(SAVE_PATH + save_name + SAVE_EXTENSION):
		save_file = FileAccess.open(BASE_SAVE_PATH, FileAccess.READ)
	else:
		save_file = FileAccess.open(SAVE_PATH + save_name + SAVE_EXTENSION, FileAccess.READ)
	save = JSON.parse_string(save_file.get_as_text())
	
	last_time = Time.get_ticks_msec()
	time_paused = false
	
	validate_save()
	return true


## Updates time in save unless time is paused
func update_time() -> void:
	if time_paused:
		return
	
	var current_time = Time.get_ticks_msec()
	save["elapsed_time"] += current_time - last_time
	last_time = current_time


## Sets whether the save should be keeping track of time
func set_time_paused(val: bool) -> void:
	if time_paused and not val:
		last_time = Time.get_ticks_msec()
	time_paused = val


## Returns time of a given save
func get_save_time(s: Dictionary) -> String:
	var hours = s["elapsed_time"] / 3600000
	var minutes = s["elapsed_time"] / 60000 - hours * 60
	var seconds = s["elapsed_time"] / 1000 - minutes * 60 - hours * 3600
	return "%02d:%02d:%02d.%03d" % [hours, minutes, seconds, s["elapsed_time"] % 1000]


## Returns elapsed time in string format
func get_time() -> String:
	update_time()
	return get_save_time(save)


## Return the save data specified by the array. If the array is, for instance, 
## ["position", "current_room"], will return save["position"]["current_room"]
func get_save_data(path: Array):
	return get_data(save, path)


## Sets val as the value stored in the specified save path. Saving it to the
## file system requires calling save_game()
func set_save_data(path: Array, val):
	set_data(save, path, val)


## Erases the entry given by path in the specified save path. Saving it to the 
## file system requires calling save_game()
func erase_save_data(path: Array):
	erase_data(save, path)


## Sets multiple values for multiple data paths in save. For each i, will set 
## path_prefix > path[i] to vals[i]
func set_save_datas(paths: Array, vals: Array, path_prefix: Array=[]):
	set_datas(save, paths, vals, path_prefix)


## Return the flag specified by the array. If the array is, for instance, 
## ["position", "current_room"], will return save["flags"]["position"]["current_room"]
func get_flag(path: String):
	var val = get_data(save["flags"], path.split("/"))
	return false if val == null else val


## Sets val as the value stored in the specified flag. Saving it to the
## file system requires calling save_game()
func set_flag(path: String, val, update_flags: bool=true):
	var path_arr: PackedStringArray = path.split("/")
	set_data(save["flags"], path_arr, val)
	if update_flags:
		get_tree().call_group("flagged", "update_flag")


## Sets multiple values for multiple data paths in save. For each i, will set 
## path_prefix > path[i] to vals[i]
func set_flags(paths: Array, vals: Array, path_prefix: Array=[]):
	set_datas(save["flags"], paths, vals, path_prefix)
	get_tree().call_group("flagged", "update_flag")
#endregion

#region OPTIONS
# ------------------------------------------------------------------------------
# OPTIONS
# ------------------------------------------------------------------------------
## Makes sure the current options file is valid by checking the values of
## relevant data. Will not fix invalid values in this data
func validate_options():
	#if options["version"] < 0.3:
	#	options["version"] = 0.3
	#and so on and so forth
	
	# Set language
	if not "locale" in options:
		options["locale"] = OS.get_locale_language()
	
	# Set controls
	if not "serialized_controls" in options["controls"]:
		set_controls()


## Loads options from default path, creating a new one if it doesn't exist
func load_options():
	var options_file
	if not FileAccess.file_exists(OPTIONS_PATH):
		options_file = FileAccess.open(BASE_OPTIONS_PATH, FileAccess.READ)
	else:
		options_file = FileAccess.open(OPTIONS_PATH, FileAccess.READ)
	options = JSON.parse_string(options_file.get_as_text())
	
	validate_options()
	
	# Apply controls
	apply_controls()
	
	# Apply locale
	TranslationServer.set_locale(options["locale"])
	
	# Apply video settings
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	set_fullscreen(get_options_data(["video", "fullscreen"]))


## Saves the current state of options to the file system
func save_options():
	var options_file = FileAccess.open(OPTIONS_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(options, "\t")
	options_file.store_line(json_string)


## Return the save data specified by the array. If the array is, for instance, 
## ["position", "current_room"], will return save["position"]["current_room"]
func get_options_data(path: Array):
	return get_data(options, path)


## Sets val as the value stored in the specified save path. Saving it to the
## file system requires calling save_game()
func set_options_data(path: Array, val):
	set_data(options, path, val)


## Sets multiple values for multiple data paths in save. For each i, will set 
## path_prefix > path[i] to vals[i]
func set_options_datas(paths: Array, vals: Array, path_prefix: Array=[]):
	set_datas(options, paths, vals, path_prefix)

# General settings -------------------------------------------------------------
## Sets the new locale value and updates translatable elements
func set_locale(value: String) -> void:
	set_options_data(["locale"], value)
	TranslationServer.set_locale(get_options_data(["locale"]))
	get_tree().call_group("localizable", "localize")


## Return the current selected language
func get_locale() -> String:
	return get_options_data(["locale"])


# Video settings ---------------------------------------------------------------
## Sets the screen the game will appear on
func set_screen_idx(value: int) -> void:
	set_options_data(["video", "screen_idx"], value)
	set_fullscreen(get_options_data(["video", "fullscreen"]))


## Gets the effective screen index
func get_screen_idx() -> int:
	var value = get_options_data(["video", "screen_idx"])
	if value == null or value < 0 or value > DisplayServer.get_screen_count():
		value = DisplayServer.get_primary_screen()
	return value


## Changes whether or not the game is in fullscreen
func set_fullscreen(value: bool) -> void:
	set_options_data(["video", "fullscreen"], value)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	var res_arr = get_options_data(["video", "resolution"])
	set_resolution(Vector2i(res_arr[0], res_arr[1]))
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if value else DisplayServer.WINDOW_MODE_WINDOWED)


## Returns if the game is in fullscreen
func get_fullscreen() -> bool:
	return get_options_data(["video", "fullscreen"])


## Changes the game's resolution
func set_resolution(size: Vector2i) -> void:
	set_options_data(["video", "resolution"], size)
	DisplayServer.window_set_size(size)
	
	# Center window
	var screen = get_screen_idx()
	var screen_origin = DisplayServer.screen_get_position(screen)
	var screen_size = DisplayServer.screen_get_size(screen)
	DisplayServer.window_set_position(screen_origin + ((screen_size - size) / 2).maxi(0))


## Returns the game's resolution
func get_resolution() -> Vector2i:
	return get_options_data(["video", "resolution"])


# Controls ---------------------------------------------------------------------
## Sets current control scheme for current aiming style
func set_controls() -> void:
	set_options_data(["controls", "serialized_controls"], InputHelper.serialize_inputs_for_actions())


## Applies saved controls for current aiming style
func apply_controls() -> void:
	InputHelper.deserialize_inputs_for_actions(get_options_data(["controls", "serialized_controls"]))


## Resets controls for current aiming_style from base options
func reset_controls() -> void:
	InputHelper.reset_all_actions()
	set_controls()


# Audio settings ---------------------------------------------------------------
## Sets volume for a particular bus. Vol is given in the range [0.0, 1.0] and 
## is converted into db
func set_bus_vol(vol: float, bus_idx: int) -> void:
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(vol))
#endregion
