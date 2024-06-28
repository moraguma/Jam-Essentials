extends Node2D


@export var amplitude: Vector2 = Vector2(0, 16)
@export var frequency: float = 0.5


@onready var base_pos = position
var time = 0


func _process(delta):
	time += delta
	
	position = base_pos + amplitude * sin(2 * PI * frequency * time)
