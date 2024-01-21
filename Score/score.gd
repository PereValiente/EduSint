extends CanvasLayer

class_name Score

@export var activity1 : Activity1
@onready var grade = $Panel_Settings/MarginContainer/VBoxContainer/GridContainer/Grade
@onready var text_grade = $Panel_Settings/MarginContainer/VBoxContainer/GridContainer/Text_grade



func _ready():
	if activity1.grade == 10:
		grade.text = "S"
		text_grade.text = "¡Excelente trabajo, has logrado la mejor puntuación!"
	elif activity1.grade < 10 and activity1.grade > 6:
		grade.text = "A"
		text_grade.text = "¡Muy bien, has asimilado la mayoría de los conceptos!"
	elif activity1.grade == 5 or activity1.grade == 4:
		grade.text = "B"
		text_grade.text = "¡Bien, has logrado responder todas las preguntas satisfactoriamente!"
	else:
		grade.text = "C"
		text_grade.text = "Toca seguir practicando con el sintetizador"


func _on_menu_button_pressed():
	get_tree().quit()
	
