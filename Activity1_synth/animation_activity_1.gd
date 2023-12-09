extends CanvasLayer

class_name Activity1

@export var synth : Synth
@onready var character_talk = $Character_talk
@onready var intro_activity_1 = $Intro_activity1/Intro_activity1
@onready var wave_activity_1 = $wave_activity1/wave_activity1



func _ready():
	await get_tree().create_timer(2).timeout
	DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"intro_activity1")
	character_talk.play("Character_talk")

func sint_talk():
	character_talk.visible = !character_talk.visible


func show_intro_button():
	intro_activity_1.visible = !intro_activity_1.visible
	character_talk.visible = !character_talk.visible


func _on_intro_activity1_pressed():
	synth.show_wave()
	intro_activity_1.visible = !intro_activity_1.visible
	DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"wave_activity1")


func show_wave_button():
	wave_activity_1.visible = !wave_activity_1.visible
	character_talk.visible = !character_talk.visible


func _on_wave_activity_1_pressed():
	DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"wave_activity1")
