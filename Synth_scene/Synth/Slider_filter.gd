extends VSlider
@onready var label_valule_filter = $"../../HBoxContainer3/Label_valule_filter"
@export var synth : Synth

func _ready() -> void:
	value = 10000


func _on_value_changed(value: float) -> void:
	label_valule_filter.text = str(value / 100)
	synth.filter_value = value
	synth.effect.set_cutoff(synth.filter_value)
	
