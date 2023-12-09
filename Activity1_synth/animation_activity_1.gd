extends CanvasLayer

class_name Activity1

@export var synth : Synth
@onready var character_talk = $Character_talk
@onready var go_activity = $Go_synth/Go_activity
@export var scene_synth : PackedScene

#var dialogue = preload("res://Activity1_synth/activity1.dialogue")


func _ready():
	await get_tree().create_timer(2).timeout
	#sint_talk()
	#show_button()
	DialogueManager.show_dialogue_balloon(load("res://Activity1_synth/activity1.dialogue"),"activity1")
	#DialogueManager.show_dialogue_balloon(dialogue)


func sint_talk():
	character_talk.visible = !character_talk.visible
	character_talk.play("Character_talk")

func show_button():
	go_activity.visible = !go_activity.visible
	character_talk.visible = !character_talk.visible
	
	


func _on_go_activity_pressed():
	synth.ballon_container.visible = !synth.ballon_container.visible
	synth.margin_container_2.visible = !synth.margin_container_2.visible
