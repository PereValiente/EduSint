extends VSlider
@onready var label_value_release = $"../../HBoxContainer3/Label_value_release"


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = 0.3

func _on_value_changed(value: float):
	value
	label_value_release.text = str(value * 100) 
