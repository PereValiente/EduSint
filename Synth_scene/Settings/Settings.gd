extends CanvasLayer


class_name Settings

@onready var panel_settings = $Panel_Settings
@onready var button_settings = $MarginContainer2/Settings
@onready var menu_button = $Panel_Settings/MarginContainer/VBoxContainer/Container/VBoxContainer/Menu
@export var menu_animation : PackedScene


func _on_settings_pressed():
	panel_settings.visible = !panel_settings.visible


func _on_menu_pressed():
	get_tree().change_scene_to_packed(menu_animation)


func _on_select_pressed():
	panel_settings.visible = !panel_settings.visible

