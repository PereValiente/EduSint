extends CanvasLayer

class_name Activity1

@export var synth : Synth
@onready var character_talk = $Character_talk
@onready var wave_activity_1 = $wave_activity1/wave_activity1
@onready var activity_1 = $Activity1/Activity1

var pressed_counter = 0
var has_made_mistake: bool = false



func _ready():
	await get_tree().create_timer(2).timeout
	DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"intro_activity1")
	character_talk.play("Character_talk")

func sint_talk():
	character_talk.visible = !character_talk.visible

func show_button():
	activity_1.visible = !activity_1.visible

func show_button_and_sint():
	activity_1.visible = !activity_1.visible
	character_talk.visible = !character_talk.visible


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
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_attack_activity1")
		
	elif pressed_counter == 5:
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_decay_activity1")
		
	elif pressed_counter == 6:
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_sustain_activity1")
		
	elif pressed_counter == 7:
		DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"question_release_activity1")



func minus_pressed_counter():
	pressed_counter -= 1

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
