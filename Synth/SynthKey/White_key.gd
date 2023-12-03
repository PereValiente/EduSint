extends Button

class_name SynthKey

@export var synth : Synth
@export var frequency : float

@onready var audio_stream_player = $AudioStreamPlayer
var playback : AudioStreamGeneratorPlayback

enum State{
	Attack,
	Decay,
	Sustain,
	Release
}

var state : State
var current_table : PackedVector2Array

var previous_sample = 0.0
var total_sample_envelope = 0

var state_start_time : float 


func _ready():
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)
	audio_stream_player.finished.connect(on_stream_finished)


func on_button_down():
	play_state(State.Attack)


func on_button_up():
	play_state(State.Release)


func on_stream_finished():
	match state:
		State.Attack:
			play_state(State.Decay)
		State.Decay:
			play_state(State.Sustain)
		State.Sustain:
			play_state(State.Sustain)
		State.Release:
			audio_stream_player.stop()


func play_state(new_state : State):
	#Calculate buffer length
	var buffer_length : float = 0
	match new_state:
		State.Attack:
			buffer_length = synth.adsr_attack * synth.sample_rate
		State.Decay:
			buffer_length = synth.adsr_decay * synth.sample_rate
		State.Sustain:
			buffer_length = int(synth.adsr_sustain * synth.sample_rate)
		State.Release:
			buffer_length =  synth.adsr_release * synth.sample_rate
	
	#Check if we have previous state
	var current_frame_value = 1
	if new_state != State.Attack:
		var current_time = Time.get_ticks_msec() / 1000.0 #Miliseconds => Seconds
		var elapsed_time = current_time - state_start_time
		
		var current_frame = elapsed_time * synth.sample_rate
		var current_value = get_envelope(state, current_frame, current_table.size())
		current_frame_value = clamp(current_value, 0.0, 1.0)
	
	
	#Create buffer and play buffer
	var buffer = oscillator(state, buffer_length, current_frame_value)
	audio_stream_player.stop()
	playback.clear_buffer()
	
	audio_stream_player.play()
	playback = audio_stream_player.get_stream_playback()
	playback.push_buffer(buffer)
	
	#Update state machine
	state = new_state
	state_start_time = Time.get_ticks_msec() / 1000.0 #Miliseconds => Seconds


func oscillator(oscilator_state:State, max_frames:int, multiplier:float = 1) -> PackedVector2Array: 
	var return_array : PackedVector2Array = []
	
	var index = 0.0
	var index_increment = (frequency * synth.sample_wave) / synth.sample_rate
	var table = synth.get_current_wave()
	var gain_dB = -20
	var amplitude = pow(10,gain_dB/20)
	
	var correction_amplitude_filter = 1
	if synth.filter_value < 1000:
		correction_amplitude_filter = 20
	
	for i in range(max_frames): 
		# Obtener cuatro puntos consecutivos para la interpolación cúbica
		var p0 = table[int(index) % synth.sample_wave]
		var p1 = table[int(index + 1) % synth.sample_wave]
		var p2 = table[int(index + 2) % synth.sample_wave]
		var p3 = table[int(index + 3) % synth.sample_wave]
		# Calcular el parámetro de interpolación (p) entre 0 y 1
		var p = index - int(index)
		
		var output = 0.0
		var envelope = get_envelope(oscilator_state, i, max_frames)
		output = cubic_interpolate(p0,p1,p2,p3,p)
		index += index_increment
		index = int(index + index_increment) % synth.sample_wave
		
		if synth.wave_type == 3: #DPW algorythm for sawtooth
			output = dpw_algorithm(output)
		
		output *= amplitude * envelope * correction_amplitude_filter #aplicar a la salida el valor de amplitud y envolvente
		return_array.push_back(Vector2.ONE * output * multiplier)
	
	if synth.wave_type == 3: #Avoid Artifacts
		var difference_frame = return_array[1] - return_array[2]
		return_array[0] = return_array[1] + difference_frame
	
	return return_array


func get_envelope(oscilator_state : State, current_frame:float, frame_count):
	match oscilator_state:
		State.Attack:
			return current_frame / frame_count
		State.Decay:
			return (1.0 - current_frame / frame_count)
		State.Sustain:
			return synth.adsr_sustain
		State.Release:
			return (1.0 - current_frame / frame_count)
	

func dpw_algorithm(input_sample):
	input_sample *= input_sample
	input_sample = difference_filter(input_sample)
	input_sample *= synth.sample_rate/(10*frequency*(1-frequency/synth.sample_rate))
	return input_sample


func difference_filter(input_sample): #H(z)=1-z^-1 filtro de retardo unitario discreto (DUR)
	var previous_sample_aux = previous_sample
	previous_sample = input_sample
	
	return input_sample - previous_sample_aux


func save_buffer(fileName, buffer):
	var to_string = ""
	for vector2 in buffer:
		to_string += str(vector2.x) + ","
	
	var file = FileAccess.open(fileName, FileAccess.WRITE)
	file.store_string(to_string)
	file.close()
