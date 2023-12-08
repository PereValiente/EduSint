extends Control
# Please check the documentation about
# Displayserver class : https://docs.godotengine.org/en/stable/classes/class_displayserver.html

#--
# Check out Colorblind addon for godot : https://github.com/paulloz/godot-colorblindness
#--

@onready var OptionContainer = get_node("%OptionContainer")
@onready var MainContainer = get_node("%MainContainer")
@export var scene_animation : PackedScene
@onready var panel_settings = $"../Panel_Settings"



func _on_select_pressed():
	panel_settings.visible = !panel_settings.visible



func _first_time() -> void:
	DisplayServer.window_set_size(DisplayServer.screen_get_size())
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	#DisplayServer.window_set_vsync_mode(Vsync)
	# -- Audio
	

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(scene_animation)



func _on_option_button_pressed():
	panel_settings.visible = !panel_settings.visible



func _on_exit_button_pressed():
	get_tree().quit()



func _on_return_button_pressed():
	MainContainer.visible = true
	OptionContainer.visible = false


