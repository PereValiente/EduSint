extends Button

class_name SynthKey

@export var synth : Synth
@export var frequency : float

@onready var audio_stream_player = $AudioStreamPlayer

var phase = 0.0
var playback : AudioStreamGeneratorPlayback = null

var increment_frame_index : int = 0

var previous_sample = 0.0
var total_sample_envelope = 0
var last_index = 0.0
var value = 0
var on_ads: bool = false
var amplitude
var correction_amplitude_filter
var last_envelope_value: float = 0.0
var envelope_frame: int = 0
var release_frame: int = 0
var fill_buffer: bool = false


func _ready():
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)
	amplitude = pow(10,-1) #-1 = gain db (-20)/20
	correction_amplitude_filter = 1
	if synth.filter_value < 1000:
		correction_amplitude_filter = 20


func _process(_delta):
	if fill_buffer:
		_fill_buffer()


func _fill_buffer():
	var increment = frequency / synth.sample_rate
	var output: float = 0.0
	var envelope: float = 0.0
	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		output = synth.generate_wave_form(phase)
		if synth.wave_type == 3: #DPW algorythm for sawtooth
			output = dpw_algorithm(output)
		
		if on_ads:
			envelope = get_ads_envelope(envelope_frame)
		else:
			envelope = get_release_envelope()
		playback.push_frame(Vector2.ONE * output * envelope * amplitude * correction_amplitude_filter)
		phase = fmod(phase + increment, 1.0)
		envelope_frame += 1
		to_fill -= 1


func on_button_down():
	audio_stream_player.play()
	playback = audio_stream_player.get_stream_playback()
	on_ads = true
	fill_buffer = true
	envelope_frame = 0
	#increment_frame_index = 0


func on_button_up():
	on_ads = false
	release_frame = envelope_frame


#func oscillator(value:int, max_frames:int) -> PackedVector2Array: 
	#var return_array : PackedVector2Array = []
#
	#var index: int = increment_frame_index
	#var index_increment = int((frequency * synth.sample_wave) / synth.sample_rate)
	#var table = synth.get_current_wave()
	#var gain_dB = -20
	#var amplitude = pow(10,gain_dB/20)
	#var correction_amplitude_filter = 1
	#if synth.filter_value < 1000:
		#correction_amplitude_filter = 20
	#
	#if value == synth.sample_rate + value:
		#value = synth.sample_rate
	#
	#for i in range(value, max_frames, 1): 
		 ##Obtener cuatro puntos consecutivos para la interpolación cúbica
		#var p0 = table[int(index) % synth.sample_wave]
		#var p1 = table[int(index + 1) % synth.sample_wave]
		#var p2 = table[int(index + 2) % synth.sample_wave]
		#var p3 = table[int(index + 3) % synth.sample_wave]
		## Calcular el parámetro de interpolación (p) entre 0 y 1
		#var p = index - int(index)
		#
		#var output = 0.0
#
		##var envelope = get_envelope(i)
		#
		#output = cubic_interpolate(p0,p1,p2,p3,p)
		#index += index_increment
		#index = int(index + index_increment) % synth.sample_wave
		#
		#if synth.wave_type == 3: #DPW algorythm for sawtooth
			#output = dpw_algorithm(output)
		#
		##output *= amplitude * envelope * correction_amplitude_filter #aplicar a la salida el valor de amplitud y envolvente
		#output *= amplitude * correction_amplitude_filter #aplicar a la salida el valor de amplitud y envolvente
		#return_array.push_back(Vector2.ONE * output)
	
	#if synth.wave_type == 3: #Avoid Artifacts
		#if return_array.size() > 2:
			#var difference_frame = return_array[1] - return_array[2]
			#return_array[0] = return_array[1] + difference_frame
		#else:
			#return_array[0] = Vector2.ZERO
	#return return_array



func get_ads_envelope(frame):
	var attack_frames = synth.adsr_attack * synth.sample_rate
	var decay_frames = synth.adsr_decay * synth.sample_rate

	if envelope_frame < attack_frames:
		return float(envelope_frame) / float(attack_frames)
	elif envelope_frame < (attack_frames + decay_frames):
		return 1.0 - (1.0 - synth.adsr_sustain) * float(envelope_frame - attack_frames) / float(decay_frames)
	else:
		return synth.adsr_sustain
	#else:
		#return synth.adsr_sustain * (1.0 - float(current_frame - (total_sample_envelope - release_frames)) / float(release_frames))


func get_release_envelope():
	var last_envelope = get_ads_envelope(release_frame)
	var release_frame_count = synth.adsr_release * synth.sample_rate
	var envelope = last_envelope * (release_frame_count - (envelope_frame - release_frame)) / release_frame_count 
	if envelope < 0:
		fill_buffer = false
	return envelope


func dpw_algorithm(input_sample):
	input_sample *= input_sample
	input_sample = difference_filter(input_sample)
	input_sample *= synth.sample_rate/(10*frequency*(1-frequency/synth.sample_rate))
	return input_sample


func difference_filter(input_sample): #H(z)=1-z^-1 filtro de retardo unitario discreto (DUR)
	var previous_sample_aux = previous_sample
	previous_sample = input_sample
	
	return input_sample - previous_sample_aux

