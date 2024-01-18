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
var time_without_acces: float = 0.0
var limit_time: float = 0.2


#Tras limit_time segundos sin estar activa la función on_played_key, 
#activa función on_no_sound
func _process(delta):
	time_without_acces += delta
	
	if time_without_acces >= limit_time:
		on_no_sound()
		time_without_acces = 0.0


#Vincular nodo synth_key a el nodo synth
func _ready():
	for child in keys:
		child.played_key.connect(on_played_key)


#Imprime señal osciloscopio 
func on_played_key(envelope:float, frequency:float):
	synth.value_frequency.text = str(int(frequency)) + " " + "Hz"
	var phase:float = 0.0
	var array: Array = []
	var increment = frequency / (synth.sample_rate*15)
	var output: float = 0.0
	for i in range(number_of_points):
		output = synth.generate_wave_form(phase)
		phase = fmod(phase + increment, 1.0)
		array.append(Vector2(
			 i * length_multiplier,
			output * envelope * 40
		))
	oscilloscope.points = array
	time_without_acces = 0.0


#Imprime linea horizontal en el osciloscopio
func on_no_sound():
	synth.value_frequency.text = ""
	var array: Array = []
	for i in range(number_of_points):
		array.append(Vector2(
			 i * length_multiplier,
			0.0
		))
			
	oscilloscope.points = array

