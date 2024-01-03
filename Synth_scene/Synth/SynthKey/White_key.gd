extends Button

class_name SynthKey

@export var synth : Synth
@export var graph : Graph
@onready var audio_stream_player = $AudioStreamPlayer
@export var frequency : float

var playback : AudioStreamGeneratorPlayback = null

var phase = 0.0
var fill_buffer: bool = false
var previous_sample = 0.0
var on_ads: bool = false
var amplitude
var correction_amplitude_filter
var last_envelope_value: float = 0.0
var envelope_frame: int = 0
var release_frame: int = 0
var button_pulsed: bool = true
#var amplitude_graph: float = 0.0

signal amplitude_graph

func _ready():
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)
	#mouse_entered.connect(on_mouse_entered)
	#mouse_exited.connect(on_mouse_exited)


func _process(_delta):
	if fill_buffer:
		_fill_buffer()


func _fill_buffer():
	var increment = frequency / synth.sample_rate
	var output: float = 0.0
	var envelope: float = 0.0
	var to_fill = playback.get_frames_available()
	amplitude = pow(10,-1) #-1 = gain db (-20)/20
	correction_amplitude_filter = 1
	if synth.filter_value < 1000:
		correction_amplitude_filter = 5
		if synth.filter_value < 400:
			correction_amplitude_filter = 15

	while to_fill > 0:
		output = synth.generate_wave_form(phase)
		if synth.wave_type == 3: #DPW algorythm for sawtooth
			output = dpw_algorithm(output)
		
		if on_ads:
			envelope = get_ads_envelope(envelope_frame)
		else:
			envelope = get_release_envelope()
		#amplitude_graph = output * envelope
		#signal amplitude_graph (amplitude_graph)
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
	#button_pulsed = true


#func on_mouse_entered():
	#if fill_buffer:
		#audio_stream_player.play()
		#playback = audio_stream_player.get_stream_playback()
		#on_ads = true
		#fill_buffer = true
		#envelope_frame = 0


#func on_mouse_exited():
	#if button_pulsed:
		#on_ads = false
		#release_frame = envelope_frame
		##button_pulsed = false


func on_button_up():
	on_ads = false
	release_frame = envelope_frame
	button_pulsed = false


func get_ads_envelope(frame):
	var attack_frames = synth.adsr_attack * synth.sample_rate
	var decay_frames = synth.adsr_decay * synth.sample_rate

	if envelope_frame < attack_frames:
		return float(envelope_frame) / float(attack_frames)
	elif envelope_frame < (attack_frames + decay_frames):
		return 1.0 - (1.0 - synth.adsr_sustain) * float(envelope_frame - attack_frames) / float(decay_frames)
	else:
		return synth.adsr_sustain


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
