extends VSlider
@onready var label_value_attack = $"../../HBoxContainer3/Label_value_attack"


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = 0.1

func _on_value_changed(value: float):
	value
	label_value_attack.text = str(value * 100) 
