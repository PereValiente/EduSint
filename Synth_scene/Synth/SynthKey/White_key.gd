extends Button

class_name SynthKey

@export var synth : Synth
@export var frequency : float

@onready var audio_stream_player = $AudioStreamPlayer

var playback : AudioStreamGeneratorPlayback

enum State{
	Stopped,
	Attack,
	Decay,
	Sustain,
	Release
}

var state : State = State.Stopped
var increment_buffer : PackedVector2Array
var increment_frame_index : int = 0

var previous_sample = 0.0
var total_sample_envelope = 0

var print_buffer : PackedVector2Array


func _ready():
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)


func _process(_delta):
	if state != State.Stopped:
		_fill_buffer()


func _fill_buffer():
	var generator_new_buffer : PackedVector2Array = []
	
	var to_fill = playback.get_frames_available()
	for i in to_fill:
		generator_new_buffer.push_back(increment_buffer[increment_frame_index])
		
		increment_frame_index += 1
		
		if increment_frame_index >= increment_buffer.size():
			on_state_finished()
		
		if state == State.Stopped:
			return
	
	playback.push_buffer(generator_new_buffer)



func on_button_down():
	audio_stream_player.play()
	playback = audio_stream_player.get_stream_playback()
	
	play_state(State.Attack)


func on_button_up():
	play_state(State.Release)


func on_state_finished():
	match state:
		State.Attack:
			play_state(State.Decay)
		State.Decay:
			play_state(State.Sustain)
		State.Sustain:
			play_state(State.Sustain)
		State.Release:
			play_state(State.Stopped)


func play_state(new_state : State):
	print("State: " + str(new_state))
	
	if new_state == State.Stopped:
		audio_stream_player.stop()
		state = State.Stopped
#		save_buffer("res://buffers/whole_buffer_8.txt", print_buffer)
		return
	
	if new_state == State.Sustain and state == State.Sustain:
		increment_frame_index = 0 #Reuse last buffer
		return
	
	
	#Calculate buffer length
	var state_length : float = 0
	match new_state:
		State.Attack:
			print_buffer = [] 
			state_length = synth.adsr_attack * synth.sample_rate
		State.Decay:
			state_length = synth.adsr_decay * synth.sample_rate
		State.Sustain:
			state_length = synth.adsr_sustain * synth.sample_rate
		State.Release:
			state_length =  synth.adsr_release * synth.sample_rate
	
	if state_length <= 0: #Go to next state if this one is lenght == 0
		state = new_state
		on_state_finished()
		return
	
	
	#Create buffer and play buffer
	increment_buffer = oscillator(new_state, state_length)
	increment_frame_index = 0
	
	#Update state machine
	state = new_state
	
	

func oscillator(oscilator_state:State, max_frames:int) -> PackedVector2Array: 
	var return_array : PackedVector2Array = []
	
	var index = 0 #Start from 0 position
	var index_increment = (frequency * synth.sample_wave) / synth.sample_rate
	
	var frames_per_period = (1 / frequency) * synth.sample_rate 
	
	max_frames += frames_per_period - fmod(max_frames, frames_per_period)
	
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
		output = cubic_interpolate(p0,p1,p2,p3,p)
		
		output = table[int(index) % synth.sample_wave]
		
		index += index_increment
		index = int(index + index_increment) % synth.sample_wave
		
		if synth.wave_type == 3: #DPW algorythm for sawtooth
			output = dpw_algorithm(output)
		
		var envelope = get_envelope(oscilator_state, i, max_frames)		
		output *= amplitude * envelope * correction_amplitude_filter #aplicar a la salida el valor de amplitud y envolvente
		return_array.push_back(Vector2.ONE * output)
		print_buffer.push_back(Vector2.ONE * output)
		
	
	if synth.wave_type == 3: #Avoid Artifacts
		if return_array.size() > 2:
			var difference_frame = return_array[1] - return_array[2]
			return_array[0] = return_array[1] + difference_frame
		else:
			return_array[0] = Vector2.ZERO

	return return_array


func get_envelope(oscilator_state : State, current_frame:float, frame_count:float):
	match oscilator_state:
		State.Attack:
			return current_frame / frame_count
		State.Decay:
			return remap(current_frame / frame_count, 0.0, 1.0, 1.0, synth.adsr_sustain)
		State.Sustain:
			return synth.adsr_sustain
		State.Release:
			var previous_frame = increment_frame_index
			previous_frame = clamp(previous_frame, 0, increment_buffer.size())
			var pre_release_value = get_envelope(state, previous_frame, increment_buffer.size())
			
			return remap(current_frame / frame_count, 0.0, 1.0, pre_release_value, 0.0)


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
	for value in buffer:
		to_string += str(value.x) + ","
	
	var file = FileAccess.open(fileName, FileAccess.WRITE)
	file.store_string(to_string)
	file.close()
