extends Control

@onready var face_talk = $First_animation/Face_talk
@onready var first_animation = $First_animation
@onready var character_talk = $Character_talk
@onready var background = $ParallaxBackground

func _ready():
	face_talk.play("Face_talk")
	character_talk.play("Character_talk")
	#Dialogo inicial
	DialogueManager.show_dialogue_balloon(load("res://Animation/introduction.dialogue"),"animation_dialogue")
	#Animación aparición syntetizador
	#$Synth/AnimationPlayer.play("popup")

func _on_timer_timeout():
	first_animation.visible = !first_animation.visible


func _on_texture_button_pressed():
	first_animation.visible = !first_animation.visible
	character_talk.visible = !character_talk.visible
	var dialogue = preload("res://Animation/first_mision.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue)


