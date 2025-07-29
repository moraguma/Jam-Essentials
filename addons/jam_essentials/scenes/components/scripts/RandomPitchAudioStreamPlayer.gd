extends AudioStreamPlayer
class_name RandomPitchAudioStreamPlayer


## Randomizes pitch up or down by this amount every time play is called
@export var randomize_pitch = 0.05
@onready var base_pitch = pitch_scale


## Plays audio with random pitch
func play(from_position: float=0.0) -> void:
	pitch_scale = max(0.01, base_pitch + randf_range(-1.0, 1.0) * randomize_pitch)
	super(from_position)
