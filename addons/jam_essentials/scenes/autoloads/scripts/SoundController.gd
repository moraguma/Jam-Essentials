extends Node


const OFF_DB = -80.0
const ON_DB = 0.0


const LERP_WEIGHT = 0.05
const VOLUME_TOLERANCE = 1


var current_music
var musics = []


@onready var sfx_container = $SFX
@onready var music_container = $Music


func _ready() -> void:
	populate_audio_list(music_container, musics)


func _process(delta: float) -> void:
	for music in musics:
		if music == current_music:
			music.volume_db = lerp(music.volume_db, ON_DB, LERP_WEIGHT)
		elif music.playing:
			music.volume_db = lerp(music.volume_db, OFF_DB, LERP_WEIGHT)
			if abs(music.volume_db - OFF_DB) < VOLUME_TOLERANCE:
				music.stop()


## Recursively fills audios with all the AudioStreamPlayers children of 
## audio_container
func populate_audio_list(audio_container: Node, audios: Array) -> void:
	for node in audio_container.get_children():
		if not node is AudioStreamPlayer:
			populate_audio_list(node, audios)
		else:
			audios.append(node)


## Gets audio in given path. If path is not an AudioStreamPlayer, gets a
## random audio child of that node. May return null if no audio is found
func get_audio(path):
	var node = get_node_or_null(path)
	if node == null:
		push_warning("Tried to play audio on non-existent AudioStreamPlayer @ %s" % [path])
		return null
	
	if not node is AudioStreamPlayer:
		var audios = []
		populate_audio_list(node, audios)
		if len(audios) == 0:
			push_warning("Tried to play random audio on empty container @ %s" % [path])
			return null
		
		node = audios.pick_random()
	node.play()


## Plays music in given path. Should be nodepath from Music node
func play_music(path):
	var played_node = get_audio("Music/" + path)
	if played_node != null:
		current_music = played_node
		played_node.play()


## Deselects current music, which will mute it gradually
func mute_music():
	current_music = null


## Plays sfx in given path. Should be nodepath from SFX node
func play_sfx(path):
	var sfx = get_audio("SFX/" + path)
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
