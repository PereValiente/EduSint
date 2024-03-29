extends CanvasLayer

@onready var face_talk = $First_animation/Face_talk
@onready var first_animation = $First_animation
@onready var character_talk = $Character_talk
@onready var background = $ParallaxBackground
@onready var ampliation = $Synth/Ampliation
@onready var synth = $Synth
@onready var go_synth = $Go_synth
@export var scene_synth : PackedScene



func _ready():
	await get_tree().create_timer(2).timeout
	face_talk.play("Face_talk")
	#Dialogo inicial
	DialogueManager.show_dialogue_balloon(load("res://Animation/introduction.dialogue"),"animation_dialogue")


#Tras finalizarse temporizador hace visible nodo First_animation
func _on_timer_timeout():
	first_animation.visible = !first_animation.visible


#Tras pulsar icono exclamación, ejecución segunda conversación con Sint
func _on_texture_button_pressed():
	first_animation.visible = !first_animation.visible
	character_talk.visible = !character_talk.visible
	var dialogue = preload("res://Animation/first_mision.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue)


#Animación aparición syntetizador obtenido
func show_synth():
	character_talk.visible = !character_talk.visible
	synth.visible = !synth.visible
	ampliation.play("popup")
	
	if ampliation.animation_finished:
		go_synth.visible = !go_synth.visible


#Animación Sint hablando
func sint_talk():
	character_talk.play("Character_talk")


func _on_go_synth_pressed():
	get_tree().change_scene_to_packed(scene_synth)
	
