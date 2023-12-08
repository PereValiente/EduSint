extends VSlider
@onready var label_value_decay = $"../../HBoxContainer3/Label_value_decay"


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = 0.2

func _on_value_changed(value: float):
	value
	label_value_decay.text = str(value * 100) 
