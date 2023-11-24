extends Node

#@export var scene_settings : PackedScene

var playback # Will hold the AudioStreamGeneratorPlayback.
@onready var sample_rate = $AudioStreamPlayer.stream.mix_rate #muestras por segundo
var sample_wave = 4096 
var total_sample_envelope = 0
var previous_sample = 0.0
var difference_filter_sample = 0.0
var dpw_sample = 0.0
var filter_value = 0.0
var correction_amplitude_filter
var cubic_interpolation_sample = 0.0
var output = [] #Amplitud de la onda
var f = 0.0 # The frequency of the sound wave.
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
	
	#Vincula la clase SynthKey cómo hijo a de las teclas blancas para que suenen 
	var children = $ColorRect/MarginContainer/HBoxContainer.get_children()
	for child in children:
		var synth_key = child as SynthKey
		if not synth_key:
			continue
		
		synth_key.set_sound_state.connect(_on_set_sound_state)
		
	#Vincula la clase SynthKey cómo hijo a de las teclas negras para que suenen 
	var black_children = $Black_key.get_children()
	for child in black_children:
		var synth_key = child as SynthKey
		if not synth_key:
			continue
		
		synth_key.set_sound_state.connect(_on_set_sound_state)


func _on_set_sound_state(frequency:float, active:bool):
	if active:
		f = frequency
		play_sound()
	else:
		$AudioStreamPlayer.stop()


func oscillator():
	var envelope = get_adsr_envelope(1) #Llamada función para obtener el valor de total_sample_envelope utilizada en t
	var index = 0.0
	var index_increment = (f * sample_wave) / sample_rate
	var table = wave_tables[wave_type]
	var gain_dB = -20
	var amplitude = pow(10,gain_dB/20)
	if filter_value < 1000:
		correction_amplitude_filter = 20
	else:
		correction_amplitude_filter = 1
	for i in range(total_sample_envelope): 
		# Obtener cuatro puntos consecutivos para la interpolación cúbica
		var p0 = table[int(index) % sample_wave]
		var p1 = table[int(index + 1) % sample_wave]
		var p2 = table[int(index + 2) % sample_wave]
		var p3 = table[int(index + 3) % sample_wave]
		# Calcular el parámetro de interpolación (p) entre 0 y 1
		var p = index - int(index)
		output.append(0.0)
		envelope = get_adsr_envelope(i)
		#cubic_interpolation(output[i])
		#output[i] = cubic_interpolation_sample
		output[i] = cubic_interpolate(p0,p1,p2,p3,p)
		index+=index_increment
		index = int(index + index_increment) % sample_wave
		if wave_type == 3: #DPW algorythm for sawtooth
			dpw_algorithm(output[i])
			output[i] = dpw_sample
		output[i] *= amplitude * envelope * correction_amplitude_filter #aplicar a la salida el valor de amplitud y envolvente
		playback.push_frame(Vector2.ONE * output[i])


func get_adsr_envelope(current_frame):
	var attack_frames = int(adsr_attack * sample_rate)
	var decay_frames = int(adsr_decay * sample_rate)
	var sustain_frames = int(adsr_sustain * sample_rate)
	var release_frames = int(adsr_release * sample_rate)
	total_sample_envelope = attack_frames + decay_frames + sustain_frames + release_frames

	if current_frame < attack_frames:
		return float(current_frame) / float(attack_frames)
	elif current_frame < (attack_frames + decay_frames):
		return 1.0 - (1.0 - adsr_sustain) * float(current_frame - attack_frames) / float(decay_frames)
	elif current_frame < (total_sample_envelope - release_frames):
		return adsr_sustain
	else:
		return adsr_sustain * (1.0 - float(current_frame - (total_sample_envelope - release_frames)) / float(release_frames))


func play_sound():
	$AudioStreamPlayer.play()
	playback = $AudioStreamPlayer.get_stream_playback()
	oscillator()


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


func difference_filter(input_sample): #H(z)=1-z^-1 filtro de retardo unitario discreto (DUR)
	difference_filter_sample = input_sample - previous_sample
	#print(difference_filter_sample)
	previous_sample = input_sample


func dpw_algorithm(input_sample):
	input_sample *= input_sample
	difference_filter(input_sample)
	input_sample = difference_filter_sample
	input_sample*=sample_rate/(10*f*(1-f/sample_rate))
	dpw_sample = input_sample


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
