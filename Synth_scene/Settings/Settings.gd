extends CanvasLayer

@export var menu_animation : PackedScene
@onready var settings = $Panel_Settings


func _on_settings_pressed():
	settings.visible = !settings.visible


func _on_select_pressed():
	settings.visible = !settings.visible


func _on_menu_pressed():
	get_tree().change_scene_to_packed(menu_animation)
