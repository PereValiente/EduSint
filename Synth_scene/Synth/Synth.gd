extends Node

class_name Synth

@onready var label_type_wave = $ColorRect/MarginContainer3/VBoxContainer/HBoxContainer3/Label_type_wave
@onready var value_frequency = $ColorRect/MarginContainer4/HBoxContainer/Value_frequency
@onready var hide_wave = $Hide_wave
@onready var hide_filter = $Hide_filter
@onready var hide_dsr = $Hide_dsr
@onready var hide_asr = $Hide_asr
@onready var hide_adr = $Hide_adr
@onready var hide_ads = $Hide_ads
@onready var hide_adsr = $Hide_adsr
@onready var hide_osciloscope = $Hide_osciloscope



var effect:AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Synth"),0)
var sample_rate = 44100
var sample_wave = 4096 
var filter_value = 0.0
var adsr_attack = 0.1
var adsr_decay = 0.2
var adsr_sustain = 0.5
var adsr_release = 0.3
var wave_type: int = 0


func _ready(): 
	label_type_wave.text = "Sin"


#Generación de los 4 tipos de forma de onda
func generate_wave_form(phase):
	match wave_type:
		0:
			return sin(phase * TAU)
		1:
			return square_wave(phase) * 0.5
		2:
			return triangle_wave(phase)
		3:
			return saw_tooth_wave(phase)


#Generación forma de onda cuadrada
func square_wave(phase: float):
	if phase < 0.5:
		return 1
	else:
		return -1


#Generación forma de onda triangular
func triangle_wave(phase):
	if phase < 0.25:
		return phase / 0.25
	elif phase < 0.75:
		return (0.5 - phase) / 0.25
	else:
		return (phase - 1) / 0.25


#Generación forma de onda diente de sierra
func saw_tooth_wave(phase):
	return (-0.5 + phase) / 0.5


#Señales de control del valor de los sliders
func _on_slider_attack_value_changed(value):
	adsr_attack = value

func _on_slider_sustain_value_changed(value):
	adsr_sustain = value

func _on_slider_decay_value_changed(value):
	adsr_decay = value

func _on_slider_release_value_changed(value):
	adsr_release = value


#Lógica para aparecer en UI texto informativo de la forma de onda
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


#Inicialización efecto filtro paso bajo (creado ya dentro de Godot)
func _on_filter_value_changed(value):
	filter_value = value
	effect.set_cutoff(filter_value)


# FUNCIONES PARA LA ACTIVIDAD 1

func show_wave():
	hide_filter.visible = !hide_filter.visible
	hide_adsr.visible = !hide_adsr.visible

func show_filter():
	hide_filter.visible = !hide_filter.visible
	hide_wave.visible = !hide_wave.visible
	hide_osciloscope.visible = !hide_osciloscope.visible

func show_attack(): 
	hide_adsr.visible = !hide_adsr.visible
	hide_dsr.visible = !hide_dsr.visible
	hide_filter.visible = !hide_filter.visible
	hide_osciloscope.visible = !hide_osciloscope.visible

func show_decay():
	hide_dsr.visible = !hide_dsr.visible
	hide_asr.visible = !hide_asr.visible

func show_sustain():
	hide_asr.visible = !hide_asr.visible
	hide_adr.visible = !hide_adr.visible

func show_release():
	hide_adr.visible = !hide_adr.visible
	hide_ads.visible = !hide_ads.visible
