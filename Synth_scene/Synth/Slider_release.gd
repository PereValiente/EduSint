extends VSlider
@onready var label_value_release = $"../../HBoxContainer3/Label_value_release"
@export var synth : Synth


func _ready() -> void:
	value = 0.1


func _on_value_changed(value: float) -> void:
	label_value_release.text = str(value * 100)
	synth.adsr_release = value
