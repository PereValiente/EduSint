extends CanvasLayer


class_name Settings

@onready var panel_settings = $Panel_Settings
@onready var button_settings = $MarginContainer2/Settings

func _on_settings_pressed():
	panel_settings.visible = !panel_settings.visible


func _on_select_pressed():
	panel_settings.visible = !panel_settings.visible

