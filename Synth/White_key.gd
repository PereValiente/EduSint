extends Button

class_name SynthKey

signal set_sound_state(frequency:float, active:bool)

@export var frequency : float

func _ready():
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)

func on_button_down():
	set_sound_state.emit(frequency, true)

func on_button_up():
	set_sound_state.emit(frequency, false)

