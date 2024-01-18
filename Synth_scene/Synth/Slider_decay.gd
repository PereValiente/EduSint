extends VSlider
@onready var label_value_decay = $"../../HBoxContainer3/Label_value_decay"
@export var synth : Synth


func _ready() -> void:
	value = 0.2


func _on_value_changed(value: float) -> void:
	label_value_decay.text = str(value * 100) 
	synth.adsr_decay = value
