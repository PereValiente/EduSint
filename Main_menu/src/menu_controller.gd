extends Control

@export var scene_animation : PackedScene
@export var scene_synth : PackedScene
@onready var panel_settings = $"../Panel_Settings"


func _on_select_pressed():
	panel_settings.visible = !panel_settings.visible


#func _first_time() -> void:
	#DisplayServer.window_set_size(DisplayServer.screen_get_size())
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(scene_animation)


func _on_synthesizer_button_pressed():
	get_tree().change_scene_to_packed(scene_synth)


func _on_option_button_pressed():
	panel_settings.visible = !panel_settings.visible


func _on_exit_button_pressed():
	get_tree().quit()



