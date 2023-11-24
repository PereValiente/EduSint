extends VSlider


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = 0.1

func _on_value_changed(value: float):
	value
