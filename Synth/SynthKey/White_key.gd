extends Button

class_name SynthKey

@export var synth : Synth
@export var frequency : float

@onready var audio_stream_player = $AudioStreamPlayer
var playback : AudioStreamGeneratorPlayback

func _ready():
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)

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
	for i in range(total_sample_ads): 
	#for i in range(total_sample_envelope): 
		# Obtener cuatro puntos consecutivos para la interpolación cúbica
		var p0 = table[int(index) % sample_wave]
		var p1 = table[int(index + 1) % sample_wave]
		var p2 = table[int(index + 2) % sample_wave]
		var p3 = table[int(index + 3) % sample_wave]
		# Calcular el parámetro de interpolación (p) entre 0 y 1
		var p = index - int(index)
		output.append(0.0)
		envelope = get_adsr_envelope(i)
		output[i] = cubic_interpolate(p0,p1,p2,p3,p)
		index+=index_increment
		index = int(index + index_increment) % sample_wave
		if wave_type == 3: #DPW algorythm for sawtooth
			dpw_algorithm(output[i])
			output[i] = dpw_sample
		output[i] *= amplitude * envelope * correction_amplitude_filter #aplicar a la salida el valor de amplitud y envolvente
		playback.push_frame(Vector2.ONE * output[i])

func oscillator_release():
	var release_frames: float = adsr_release * sample_rate
	
	playback.clear_buffer()
	
	var index = 0 #Get real index - With start time
	var index_increment = (f * sample_wave) / sample_rate
	var table = wave_tables[wave_type]
	var gain_dB = -20
	var amplitude = pow(10,gain_dB/20)
	
	if filter_value < 1000:
		correction_amplitude_filter = 20
	else:
		correction_amplitude_filter = 1
	
	var envelope
	for i in range(total_sample_ads): 
	#for i in range(total_sample_envelope): 
		# Obtener cuatro puntos consecutivos para la interpolación cúbica
		var p0 = table[int(index) % sample_wave]
		var p1 = table[int(index + 1) % sample_wave]
		var p2 = table[int(index + 2) % sample_wave]
		var p3 = table[int(index + 3) % sample_wave]
		# Calcular el parámetro de interpolación (p) entre 0 y 1
		var p = index - int(index)
		output.append(0.0)
		envelope = get_r_envelope(i)
		output[i] = cubic_interpolate(p0,p1,p2,p3,p)
		index+=index_increment
		index = int(index + index_increment) % sample_wave
		if wave_type == 3: #DPW algorythm for sawtooth
			dpw_algorithm(output[i])
			output[i] = dpw_sample
		output[i] *= amplitude * envelope * correction_amplitude_filter #aplicar a la salida el valor de amplitud y envolvente
		playback.push_frame(Vector2.ONE * output[i])

func get_adsr_envelope(current_frame: float):
	var attack_frames: float = adsr_attack * sample_rate
	var decay_frames: float = adsr_decay * sample_rate
	var sustain_frames = int(adsr_sustain * sample_rate)
	var release_frames: float = adsr_release * sample_rate
	#total_sample_envelope = attack_frames + decay_frames + sustain_frames + release_frames
	total_sample_ads = attack_frames + decay_frames + sustain_frames

	if current_frame < attack_frames:
		return current_frame / attack_frames
	elif current_frame < (attack_frames + decay_frames):
		return 1.0 - (1.0 - adsr_sustain) * (current_frame - attack_frames) / decay_frames
	elif current_frame < total_sample_ads:
	#elif current_frame < (total_sample_envelope - release_frames):
		return adsr_sustain
	#else:
	#	return adsr_sustain * (1.0 - float(current_frame - (total_sample_envelope - release_frames)) / release_frames)


func get_r_envelope (current_frame: float):
	var attack_frames: float = adsr_attack * sample_rate
	var decay_frames: float = adsr_decay * sample_rate
	var sustain_frames = int(adsr_sustain * sample_rate)
	var release_frames: float = adsr_release * sample_rate
	total_sample_envelope = attack_frames + decay_frames + sustain_frames + release_frames
	return adsr_sustain * (1.0 - float(current_frame - (total_sample_envelope - release_frames)) / release_frames)

func dpw_algorithm(input_sample):
	input_sample *= input_sample
	difference_filter(input_sample)
	input_sample = difference_filter_sample
	input_sample*=sample_rate/(10*f*(1-f/sample_rate))
	dpw_sample = input_sample

func difference_filter(input_sample): #H(z)=1-z^-1 filtro de retardo unitario discreto (DUR)
	difference_filter_sample = input_sample - previous_sample
	#print(difference_filter_sample)
	previous_sample = input_sample

func play_sound():
	synth_audio_1.play()
	playback = synth_audio_1.get_stream_playback()
	oscillator()



if active:
		f = frequency
		play_sound()
	else:
		oscillator_release()
#		synth_audio_1.stop()
