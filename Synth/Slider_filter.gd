extends VSlider


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = 10000

func _on_value_changed(value: float):
	value
