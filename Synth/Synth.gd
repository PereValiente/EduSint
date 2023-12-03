extends Node

class_name Synth

#@export var scene_settings : PackedScene

var playback : AudioStreamGeneratorPlayback # Will hold the AudioStreamGeneratorPlayback.
@onready var sample_rate = $Synth_audio_1.stream.mix_rate #muestras por segundo (44100)
@onready var synth_audio_1 = $Synth_audio_1
var sample_wave = 4096 
var total_sample_envelope = 0
var total_sample_ads = 0
var previous_sample = 0.0
var difference_filter_sample = 0.0
var dpw_sample = 0.0
var filter_value = 0.0
var correction_amplitude_filter
var cubic_interpolation_sample = 0.0
var output = [] #Amplitud de la onda
var adsr_attack = 0.1
var adsr_decay = 0.2
var adsr_sustain = 0.5
var adsr_release = 0.3
var wave_type = 0
var wave_tables = []


func _ready(): #Genera las tablas de las 4 formas de onda
	wave_tables.append(generate_sine_wave_table(sample_wave))
	wave_tables.append(generate_square_wave_table(sample_wave))
	wave_tables.append(generate_triangle_wave_table(sample_wave))
	wave_tables.append(generate_sawtooth_wave_table(sample_wave))



func generate_sine_wave_table(sample_wave):
	var table = []
	for i in range(sample_wave):
		var angle = (i * TAU) / float (sample_wave) 
		var sample_s = sin(angle)
		table.append(sample_s) #almacena sample_wave muestras de la amplitud de un seno
		#print(sample_s)
	return table


func generate_square_wave_table(sample_wave):
	var table = []
	var half_sample_wave = sample_wave / 2
	for i in range(sample_wave):
		var sample_c = 0.0
		if i < half_sample_wave:
			sample_c = 1.0 
		else: 
			sample_c = -1.0
		table.append(sample_c)
	return table


func generate_triangle_wave_table(sample_wave):
	var table = []
	var quarter_sample_wave = float(sample_wave / 4)
	var sample_t = 0.0
	for i in range(sample_wave):
		if i < quarter_sample_wave:
			sample_t = i / quarter_sample_wave
		elif i < 3 * quarter_sample_wave:
			sample_t = (2 * quarter_sample_wave - i) / quarter_sample_wave
		elif i < 4 * quarter_sample_wave:
			sample_t = (i - 4 * quarter_sample_wave) / quarter_sample_wave
		table.append(sample_t)
	return table


func generate_sawtooth_wave_table(sample_wave):
	var table = []
	var half_sample_wave = sample_wave / 2
	var sample = 0.0
	for i in range(sample_wave):
		sample = float(-half_sample_wave + i) / half_sample_wave
		table.append(sample)
	return table


func _on_slider_attack_value_changed(value):
	adsr_attack = value

func _on_slider_sustain_value_changed(value):
	adsr_sustain = value

func _on_slider_decay_value_changed(value):
	adsr_decay = value

func _on_slider_release_value_changed(value):
	adsr_release = value

func _on_wave_type_value_changed(value):
	wave_type = value

func _on_filter_value_changed(value):
	filter_value = value
	var effect:AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("music"),0)
	effect.set_cutoff(filter_value)


#func _on_settings_pressed():
#	get_tree().change_scene_to_packed(scene_settings)
