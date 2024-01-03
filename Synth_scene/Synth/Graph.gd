extends Node2D

class_name Graph

@export var keys : Array[SynthKey]
@export var synth_key = SynthKey

@onready var oscilloscope = $Oscilloscope
@export var number_of_points: int = 99700
@export var length_multiplier: float = 0.01
@export var amplitude:float = 0.003

func _ready():
	for child in keys:
		#child.played_key.connect(on_played_key)
		child.played_key.connect(on_played_key)

##funcion operativa dinamica pero capta parte muy pequeña de la señal
#func on_played_key(amplitude:float):
	#var array: Array = []
	#for i in range(number_of_points):
		#array.append(Vector2(
			 #i * length_multiplier,
			 #i * amplitude * 0.008 
		#))
	#oscilloscope.points = array
	


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


func on_played_key(envelope:float, frequency:float):
	var array: Array = []
	
	for i in range(number_of_points):
			array.append(Vector2(
				 i * length_multiplier,
				 sin(i * frequency / 100000) * envelope * 40
			))

	oscilloscope.points = array

