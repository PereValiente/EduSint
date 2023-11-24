extends VSlider


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = 0.3

func _on_value_changed(value: float):
	value
