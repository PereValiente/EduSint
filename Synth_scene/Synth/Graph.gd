extends Node2D

class_name Graph

@export var synth_key : SynthKey
@export var synth : Synth
@export var keys : Array[SynthKey]


@onready var oscilloscope = $Oscilloscope
@export var number_of_points: int = 99700
@export var amplitude: float = 30.0
@export var length_multiplier: float = 0.01

func _ready():
	for child in keys:
		child.played_key.connect(on_played_key)


func on_played_key(amplitude:float):
	var array: Array = []
	for i in range(number_of_points):
		array.append(Vector2(
			 i * length_multiplier,
			 sin(i * 0.00003 * synth_key.frequency) * amplitude
		))

	oscilloscope.points = array
	


#func _process(_delta: float) -> void:
	#var array: Array = []
	#
	#for i in range(number_of_points):
			#array.append(Vector2(
				 #i * length_multiplier,
				 #sin(i * 0.00003 * synth_key.frequency) * amplitude
			#))
#
	#oscilloscope.points = array

