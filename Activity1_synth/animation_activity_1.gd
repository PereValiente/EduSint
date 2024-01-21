extends CanvasLayer

class_name Activity1

@export var synth : Synth
@onready var character_talk = $Character_talk
@onready var activity_1 = $Activity1/Activity1
@onready var panel_synth = $Synth
@onready var settings = $Settings
@onready var label_grade = $Panel_score/MarginContainer/VBoxContainer/GridContainer/Label_grade
@onready var label_text_grade = $Panel_score/MarginContainer/VBoxContainer/GridContainer/Label_text_grade

@onready var panel_score = $Panel_score



var pressed_counter: int = 0
var has_made_mistake: bool = false
var grade = 10



func _ready():
	await get_tree().create_timer(120).timeout
	DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"intro_activity1")
	character_talk.play("Character_talk")


func sint_talk():
	character_talk.visible = !character_talk.visible


func show_button():
	activity_1.visible = !activity_1.visible


func show_button_and_sint():
	activity_1.visible = !activity_1.visible
	character_talk.visible = !character_talk.visible


#Ejecución lógica preguntas conocimiento del sintetizador
func _on_activity_1_pressed():
	pressed_counter += 1
	
	if pressed_counter == 1:
		synth.adsr_attack = 0.01
		synth.adsr_decay = 0.0
		synth.adsr_sustain = 1.0
		synth.adsr_release = 0.05
		synth.filter_value = 100000
		synth.show_wave()
		activity_1.visible = !activity_1.visible
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"wave_activity1")
	
	elif pressed_counter == 2:
		synth.wave_type = 3
		activity_1.visible = !activity_1.visible
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_wave_activity1")
		
	elif pressed_counter == 3:
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_filter_activity1")
		
	elif pressed_counter == 4:
		synth.adsr_attack = 0.1
		synth.adsr_sustain = 0.1
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_attack_activity1")
		
	elif pressed_counter == 5:
		synth.adsr_decay = 0.02
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_decay_activity1")
		
	elif pressed_counter == 6:
		synth.adsr_sustain = 1.0
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_sustain_activity1")
		
	elif pressed_counter == 7:
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_release_activity1")



func end_game():
	panel_synth.visible = !panel_synth.visible
	settings.visible = !settings.visible
	if grade == 10:
		label_grade.text = "S"
		label_text_grade.text = "¡Excelente trabajo, has logrado la mejor puntuación!"
	elif grade < 10 and grade > 6:
		label_grade.text = "A"
		label_text_grade.text = "¡Muy bien, has asimilado la mayoría de los conceptos!"
	elif grade == 5 or grade == 4:
		label_grade.text = "B"
		label_text_grade.text = "¡Bien, has logrado responder todas las preguntas satisfactoriamente!"
	else:
		label_grade.text = "C"
		label_text_grade.text = "Toca seguir practicando con el sintetizador"
	panel_score.visible = !panel_score.visible


func minus_pressed_counter():
	pressed_counter -= 1
	grade -= 1

func show_filter():
	synth.show_filter()

func show_attack():
	synth.show_attack()

func show_decay():
	synth.show_decay()

func show_sustain():
	synth.show_sustain()

func show_release():
	synth.show_release()

func _on_exit_pressed():
	get_tree().quit()
