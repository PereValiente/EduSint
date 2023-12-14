extends Button

class_name SynthKey

@export var synth : Synth
@export var frequency : float

@onready var audio_stream_player = $AudioStreamPlayer


#var sample_hz = 22050.0 # Keep the number of samples to mix low, GDScript is not super fast.
#var pulse_hz = 440.0
#var phase = 0.0
#


#func _process(_delta):
	#_fill_buffer()
#
#
#func _fill_buffer():
	#var increment = pulse_hz / sample_hz
#
	#var to_fill = playback.get_frames_available()
	#while to_fill > 0:
		#playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		#phase = fmod(phase + increment, 1.0)
		#to_fill -= 1
#
#
#func _ready():
	#audio_stream_player.stream.mix_rate = sample_hz # Setting mix rate is only possible before play().
	#audio_stream_player.play()
	#playback = audio_stream_player.get_stream_playback()
	#_fill_buffer() # Prefill, do before play() to avoid delay.


var playback : AudioStreamGeneratorPlayback = null


var increment_buffer : PackedVector2Array
var increment_frame_index : int = 0

var previous_sample = 0.0
var total_sample_envelope = 0
var last_index = 0.0
var value = 0



func _ready():
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)


func on_button_down():
	audio_stream_player.play()
	playback = audio_stream_player.get_stream_playback()
	playback.push_buffer(oscillator(value, synth.sample_rate + value))

func on_button_up():
	#play_state(State.Release)
	audio_stream_player.stop()



#func play_state(new_state : State):
	#
	#if new_state == State.Stopped:
		#audio_stream_player.stop()
		#state = State.Stopped
##		save_buffer("res://buffers/whole_buffer_4.txt", print_buffer)
		#return
	#
	##Calculate buffer length
	#var state_length : float = 0
	#
##Create buffer and play buffer
	##var buffer = basic_wave_oscilator(new_state, state_length)
	##var buffer = oscillator(new_state, state_length)
	#increment_frame_index = 0
#
	##Update state machine
	#
	##increment_buffer = buffer


#func fill_audio_buffer(buffer_size):
	#var data = playback.push_buffer(basic_wave_oscilator(synth.sample_rate * 0.1))

#
#func basic_wave_oscilator(max_frames:int) -> PackedVector2Array:
	#var return_array : PackedVector2Array = []
	#var index = increment_frame_index
	#var index_increment = (frequency * synth.sample_wave) / synth.sample_rate
	#var table = synth.get_current_wave()
	#var gain_dB = -20
	#var amplitude = pow(10,gain_dB/20)
	#
	#for i in range(max_frames):
		## Obtener cuatro puntos consecutivos para la interpolación cúbica
		#var p0 = table[int(index) % synth.sample_wave]
		#var p1 = table[int(index + 1) % synth.sample_wave]
		#var p2 = table[int(index + 2) % synth.sample_wave]
		#var p3 = table[int(index + 3) % synth.sample_wave]
		## Calcular el parámetro de interpolación (p) entre 0 y 1
		#var p = index - int(index)
#
		#var output = 0.0
		#output = cubic_interpolate(p0,p1,p2,p3,p)
		##if i == 0:
			##index = last_index
		#
		#index += index_increment
		#index = int(index + index_increment) % synth.sample_wave
		##if max_frames > i:
			##index = int(index + index_increment) % synth.sample_wave
		##else:
			##last_index = index
		#output *= amplitude
		#return_array.push_back(Vector2.ONE * output)
	#return return_array


func oscillator(value:int, max_frames:int) -> PackedVector2Array: 
	var return_array : PackedVector2Array = []

	var index = increment_frame_index
	var index_increment = (frequency * synth.sample_wave) / synth.sample_rate
	var table = synth.get_current_wave()
	var gain_dB = -20
	var amplitude = pow(10,gain_dB/20)
	var correction_amplitude_filter = 1
	
	if synth.filter_value < 1000:
		correction_amplitude_filter = 20
	
	for i in range(value, max_frames, 1): 
		 #Obtener cuatro puntos consecutivos para la interpolación cúbica
		var p0 = table[int(index) % synth.sample_wave]
		var p1 = table[int(index + 1) % synth.sample_wave]
		var p2 = table[int(index + 2) % synth.sample_wave]
		var p3 = table[int(index + 3) % synth.sample_wave]
		# Calcular el parámetro de interpolación (p) entre 0 y 1
		var p = index - int(index)
		
		var output = 0.0
		
		var envelope = get_envelope(i)
		
		output = cubic_interpolate(p0,p1,p2,p3,p)
		index += index_increment
		index = int(index + index_increment) % synth.sample_wave
		
		if synth.wave_type == 3: #DPW algorythm for sawtooth
			output = dpw_algorithm(output)
		
		output *= amplitude * envelope * correction_amplitude_filter #aplicar a la salida el valor de amplitud y envolvente
		return_array.push_back(Vector2.ONE * output)
	
	if synth.wave_type == 3: #Avoid Artifacts
		if return_array.size() > 2:
			var difference_frame = return_array[1] - return_array[2]
			return_array[0] = return_array[1] + difference_frame
		else:
			return_array[0] = Vector2.ZERO

	return return_array



func get_envelope(current_frame):
	var attack_frames = synth.adsr_attack * synth.sample_rate
	var decay_frames = synth.adsr_decay * synth.sample_rate
	var sustain_frames = synth.adsr_sustain * synth.sample_rate
	var release_frames = synth.adsr_release * synth.sample_rate
	total_sample_envelope = attack_frames + decay_frames + sustain_frames + release_frames

	if current_frame < attack_frames:
		return float(current_frame) / float(attack_frames)
	elif current_frame < (attack_frames + decay_frames):
		return 1.0 - (1.0 - synth.adsr_sustain) * float(current_frame - attack_frames) / float(decay_frames)
	elif current_frame < (total_sample_envelope - release_frames):
		return synth.adsr_sustain
	else:
		return synth.adsr_sustain * (1.0 - float(current_frame - (total_sample_envelope - release_frames)) / float(release_frames))



func dpw_algorithm(input_sample):
	input_sample *= input_sample
	input_sample = difference_filter(input_sample)
	input_sample *= synth.sample_rate/(10*frequency*(1-frequency/synth.sample_rate))
	return input_sample


func difference_filter(input_sample): #H(z)=1-z^-1 filtro de retardo unitario discreto (DUR)
	var previous_sample_aux = previous_sample
	previous_sample = input_sample
	
	return input_sample - previous_sample_aux

