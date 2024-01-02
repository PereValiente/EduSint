extends Node2D

class_name Graph

@export var synth_key : SynthKey

@onready var oscilloscope = $Oscilloscope
@export var number_of_points: int = 99700
@export var amplitude: float = 30.0
@export var length_multiplier: float = 0.01


func _process(delta: float) -> void:
	var array: Array = []
	
	for i in range(number_of_points):
			array.append(Vector2(
				 i * length_multiplier,
				 sin(i * 0.02 * synth_key.frequency) * amplitude
			))
		
	oscilloscope.points = array

