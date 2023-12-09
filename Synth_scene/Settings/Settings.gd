extends CanvasLayer

@onready var settings = $Panel_Settings

func _on_settings_pressed():
	settings.visible = !settings.visible


func _on_select_pressed():
	settings.visible = !settings.visible

