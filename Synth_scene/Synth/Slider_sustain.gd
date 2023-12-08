extends VSlider
@onready var label_value_sustain = $"../../HBoxContainer3/Label_value_sustain"


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = 0.5

func _on_value_changed(value: float):
	value
	label_value_sustain.text = str(value * 100) 
