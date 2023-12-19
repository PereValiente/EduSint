extends Node

class_name Synth


var playback : AudioStreamGeneratorPlayback # Will hold the AudioStreamGeneratorPlayback.
@onready var sample_rate = $Synth_audio_1.stream.mix_rate #muestras por segundo (44100)
@onready var synth_audio_1 = $Synth_audio_1
@onready var label_type_wave = $ColorRect/MarginContainer2/VBoxContainer/HBoxContainer3/Label_type_wave
@onready var hide_wave = $Hide_wave
@onready var hide_filter = $Hide_filter
@onready var hide_dsr = $Hide_dsr
@onready var hide_asr = $Hide_asr
@onready var hide_adr = $Hide_adr
@onready var hide_ads = $Hide_ads
@onready var hide_adsr = $Hide_adsr



var sample_wave = 4096 
var filter_value = 0.0
var cubic_interpolation_sample = 0.0
var adsr_attack = 0.1
var adsr_decay = 0.2
var adsr_sustain = 0.5
var adsr_release = 0.3
var wave_type: int = 0
var wave_tables = []


func _ready(): #Genera las tablas de las 4 formas de onda
	wave_tables.append(generate_sine_wave_table(sample_wave))
	wave_tables.append(generate_square_wave_table(sample_wave))
	wave_tables.append(generate_triangle_wave_table(sample_wave))
	wave_tables.append(generate_sawtooth_wave_table(sample_wave))
	label_type_wave.text = "Sin"


func get_current_wave():
	return wave_tables[wave_type]

func generate_wave_form(phase):
	match wave_type:
		0:
			return sin(phase * TAU)
		1:
			return square_wave(phase)
		2:
			return triangle_wave(phase)
		3:
			return saw_tooth_wave(phase)

func square_wave(phase: float):
	if phase < 0.5:
		return 1
	else:
		return -1

func triangle_wave(phase):
	if phase < 0.25:
		return phase / 0.25
	elif phase < 0.75:
		return (0.5 - phase) / 0.25
	else:
		return (phase - 1) / 0.25

func saw_tooth_wave(phase):
	return (-0.5 + phase) / 0.5


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
	
	if value == 0:
		label_type_wave.text = "Sin"
	elif value == 1:
		label_type_wave.text = "Square"
	elif value == 2:
		label_type_wave.text = "Triangle"
	elif value == 3:
		label_type_wave.text = "Saw tooth"
	

func _on_filter_value_changed(value):
	filter_value = value
	var effect:AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Synth"),0)
	effect.set_cutoff(filter_value)


#	get_tree().change_scene_to_packed(scene_settings)

# FUNCIONES PARA LA ACTIVIDAD 1

func show_wave():
	hide_filter.visible = !hide_filter.visible
	hide_adsr.visible = !hide_adsr.visible


func show_filter():
	hide_filter.visible = !hide_filter.visible

func show_attack(): 
	hide_wave.visible = !hide_wave.visible
	hide_adsr.visible = !hide_adsr.visible
	hide_dsr.visible = !hide_dsr.visible
	hide_filter.visible = !hide_filter.visible

func show_decay():
	hide_dsr.visible = !hide_dsr.visible
	hide_asr.visible = !hide_asr.visible

func show_sustain():
	hide_asr.visible = !hide_asr.visible
	hide_adr.visible = !hide_adr.visible

func show_release():
	hide_adr.visible = !hide_adr.visible
	hide_ads.visible = !hide_ads.visible
