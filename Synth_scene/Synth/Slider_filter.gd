extends VSlider
@onready var label_valule_filter = $"../../HBoxContainer3/Label_valule_filter"


func _ready() -> void:
	value_changed.connect(_on_value_changed)
	value = 10000


func _on_value_changed(value: float) -> void:
	label_valule_filter.text = str(value / 100) 
