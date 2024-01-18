extends VSlider
@onready var label_value_attack = $"../../HBoxContainer3/Label_value_attack"
@export var synth : Synth


func _ready() -> void:
	value = 0.1


func _on_value_changed_attack(value: float) -> void:
	label_value_attack.text = str(value * 100)
	synth.adsr_attack = value
