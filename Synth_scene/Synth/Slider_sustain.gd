extends VSlider
@onready var label_value_sustain = $"../../HBoxContainer3/Label_value_sustain"
@export var synth : Synth


func _ready() -> void:
	value = 0.5


func _on_value_changed(value: float) -> void:
	label_value_sustain.text = str(value * 100) 
	synth.adsr_sustain = value
