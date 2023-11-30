extends Control

@onready var face_talk = $First_animation/Face_talk
@onready var first_animation = $First_animation
@onready var character_talk = $Character_talk
@onready var background = $ParallaxBackground

func _ready():
	#DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/test.dialogue"), "Prueba")
	face_talk.play("Face_talk")
	character_talk.play("Character_talk")
	
	"""
	print(background.scroll_offset.x)
	if background.scroll_offset.x > 800:
		face_talk.play("Face_talk")
		character_talk.play("Character_talk")
	"""

func _on_timer_timeout():
	first_animation.visible = !first_animation.visible


func _on_texture_button_pressed():
	var dialogue = preload("res://Animation/test.dialogue")
	#DialogueManager.show_example_dialogue_balloon(animation_dialogue, dialogue)
