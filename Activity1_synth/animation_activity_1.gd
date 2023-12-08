extends CanvasLayer

class_name Activity1

@export var synth : Synth
@onready var character_talk = $Character_talk
@onready var go_activity = $Go_synth/Go_activity

@export var scene_synth : PackedScene



func _ready():
	await get_tree().create_timer(2).timeout
	#Dialogo inicial
	show_sint()
	DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"activity1")


func _on_texture_button_pressed():
	character_talk.visible = !character_talk.visible
	var dialogue = preload("res://Animation/first_mision.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue)


func show_sint():
	character_talk.visible = !character_talk.visible
	character_talk.play("Character_talk")

func show_button():
	go_activity.visible = !go_activity.visible
	character_talk.visible = !character_talk.visible


func _on_go_activity_pressed():
	synth.ballon_container.visible = !synth.ballon_container.visible
	synth.margin_container_2.visible = !synth.margin_container_2.visible
