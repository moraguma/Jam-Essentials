extends Node


const OFF_DB = -80.0
const ON_DB = 0.0


const LERP_WEIGHT = 0.05
const VOLUME_TOLERANCE = 1


var sfx = {}
var music = {}
var current_music


@onready var sfx_container = $SFX
@onready var music_container = $Music


func _ready():
	populate_sound_dict(music_container, music, Globals.MUSIC_BUS)
	populate_sound_dict(sfx_container, sfx, Globals.SFX_BUS)


func populate_sound_dict(container: Node, dict: Dictionary, bus: int, prefix: String=""):
	for node in container.get_children():
		if not node is AudioStreamPlayer:
			populate_sound_dict(node, dict, bus, prefix + node.name + "/")
		else:
			dict[prefix + node.name] = node
			node.set_bus(Globals.BUS_TO_STRING[bus])


func get_audio_player(dict: Dictionary, path: String) -> AudioStreamPlayer:
	if Globals.check_and_error(not path in dict, "Tried playing sound with invalid path %s" % [path]) or Globals.check_and_error(not dict[path] is AudioStreamPlayer, "%s is not an AudioStreamPlayer"):
		return null
	return dict[path]


func _process(delta):
	for music_name in music:
		if music[music_name].playing:
			music[music_name].volume_db = lerp(music[music_name].volume_db, ON_DB if music_name == current_music else OFF_DB, LERP_WEIGHT)
			
			if abs(music[music_name].volume_db - OFF_DB) < VOLUME_TOLERANCE:
				music[music_name].stop()


## Plays music in given path. Should be nodepath from Music node
func play_music(path):
	var music = get_audio_player(music, path)
	if music != null:
		music.play()
		current_music = path


## Stops playing current music
func mute_music():
	current_music = null


## Plays sfx in given path. Should be nodepath from SFX node
func play_sfx(path):
	var sfx = get_audio_player(sfx, path)
	if sfx != null:
		sfx.stop()
		sfx.play()


## Sets volume for given bus. Bus numbers are defined as consts in Globals
func set_volume(bus: int, volume: float):
	volume = clamp(volume, 0.0, 1.0)
	
	if volume <= 0.0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, 20 * log(volume))
