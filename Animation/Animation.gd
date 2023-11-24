extends Control

@onready var face_talk = $Face_talk
@onready var character_talk = $Character_talk
@onready var background = $ParallaxBackground

func _ready():
	face_talk.play("Face_talk")
	character_talk.play("Character_talk")
	"""
	print(background.scroll_offset.x)
	if background.scroll_offset.x > 800:
		face_talk.play("Face_talk")
		character_talk.play("Character_talk")
	"""
