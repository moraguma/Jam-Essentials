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
	for node in music_container.get_children():
		music[node.name] = node
	for node in sfx_container.get_children():
		sfx[node.name] = node


func _process(delta):
	for music_name in music:
		music[music_name].volume_db = lerp(music[music_name].volume_db, ON_DB if music_name == current_music else OFF_DB, LERP_WEIGHT)
		
		if abs(music[music_name].volume_db - OFF_DB) < VOLUME_TOLERANCE and music[music_name].playing:
			music[music_name].stop()


func play_music(music_name):
	assert(music_name in music, "Music {0} not found".format([music_name]))
	music[music_name].play()
	current_music = music_name


func mute_music():
	current_music = null


func play_sfx(sfx_name):
	assert(sfx_name in sfx, "SFX {0} not found".format([sfx_name]))
	sfx[sfx_name].stop()
	sfx[sfx_name].play()


func set_volume(bus: int, volume: float):
	volume = clamp(volume, 0.0, 1.0)
	
	if volume <= 0.0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, 20 * log(volume))
