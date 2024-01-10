extends Node2D

class_name Graph

@export var keys : Array[SynthKey]
@export var synth_key : SynthKey
@export var synth : Synth

@onready var oscilloscope = $Oscilloscope
@export var number_of_points: int = 99700
@export var length_multiplier: float = 0.01
@export var amplitude:float = 0.003

var wave_type:int = 0
var phase:float = 0.0

func _ready():
	for child in keys:
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
	var increment = frequency / synth.sample_rate
	var output: float = 0.0

	for i in range(number_of_points):
		output = synth.generate_wave_form(phase)
		
		phase = fmod(phase + increment, 1.0)
		array.append(Vector2(
			 i * length_multiplier,
			output * envelope * 40
		))

	oscilloscope.points = array

#func on_played_key(envelope:float, frequency:float):
	#var array: Array = []
	#var y_value:float = 0.0
	#var phase:float = 0.0
	#for i in range(number_of_points):
		#y_value = sin(i * frequency / 100000) * envelope * 40
		#phase = i * frequency / 100000
		#match wave_type:
			#0:
				#y_value 
			#1:
				#if y_value > 0:
					#y_value = envelope * 40
				#else:
					#y_value = -envelope * 40
			#2:
				#if sin(i * frequency / 100000) < 1: 
					#y_value = (phase / 0.25) * envelope
				#elif phase < 0.75:
					#y_value = ((0.5 - phase) / 0.25) * envelope
				#else:
					#y_value = ((phase - 1) / 0.25) * envelope
				##y_value = 0
			#3:
				#phase = fmod(phase, TAU)
				#y_value =  (abs(phase) * envelope * 13) - 40
				#
		#array.append(Vector2(
			 #i * length_multiplier,
			#y_value
		#))
#
	#oscilloscope.points = array


func on_no_sound():
	var array: Array = []
	for i in range(number_of_points):
		array.append(Vector2(
			 i * length_multiplier,
			0.0
		))
			
	oscilloscope.points = array


func integrate_trapezoidal(a,b,num_intervals):
	var h = ((b - a) / num_intervals)
	var integral = a


func _on_slider_wave_value_changed(value):
	wave_type = value
