extends Control


class_name Menu

@export var settings : Settings
@export var scene_animation : PackedScene
@export var synth_and_settings_scene : PackedScene
@onready var panel_settings = $"../Panel_Settings"


func _ready():
	settings.button_settings.visible = !settings.button_settings.visible
	settings.menu_button.visible = !settings.menu_button.visible

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(scene_animation)
	settings.menu_button.visible = !settings.menu_button.visible


func _on_synthesizer_button_pressed():
	get_tree().change_scene_to_packed(synth_and_settings_scene)
	settings.menu_button.visible = !settings.menu_button.visible


func _on_option_button_pressed():
	settings.panel_settings.visible = !settings.panel_settings.visible


func _on_exit_button_pressed():
	get_tree().quit()

