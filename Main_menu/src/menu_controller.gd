extends Control
# Please check the documentation about
# Displayserver class : https://docs.godotengine.org/en/stable/classes/class_displayserver.html

#--
# Check out Colorblind addon for godot : https://github.com/paulloz/godot-colorblindness
#--

@onready var OptionContainer = get_node("%OptionContainer")
@onready var MainContainer = get_node("%MainContainer")
@export var scene_animation : PackedScene

# Config file
# Move it into a singleton 
var SettingsFile = ConfigFile.new()
# I'm a Vector3 instead of 3 var float
# - x : General , y : Music , z : SFX
var Audio : Vector3 = Vector3(70.0,70.0,70.0)


func _first_time() -> void:
	DisplayServer.window_set_size(DisplayServer.screen_get_size())
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	#DisplayServer.window_set_vsync_mode(Vsync)
	# -- Audio
	SettingsFile.set_value("Audio","Master",Audio.x)
	SettingsFile.set_value("Audio","Music",Audio.y)
	SettingsFile.set_value("Audio","Efectos de sonido",Audio.z)

	SettingsFile.save("res://settings.cfg")


func _load_settings():
	if (SettingsFile.load("res://settings.cfg") != OK):
		_first_time()
	else:
		pass
func _save_settings() -> void:
	# -- Audio
	SettingsFile.set_value("Audio","Master",Audio.x)
	SettingsFile.set_value("Audio","Music",Audio.y)
	SettingsFile.set_value("Audio","Efectos de sonido",Audio.z)
	
	SettingsFile.save("res://settings.cfg")


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(scene_animation)



func _on_option_button_pressed():
	OptionContainer.visible = true
	MainContainer.visible = false



func _on_exit_button_pressed():
	get_tree().quit()


func _on_window_mode_optionbutton_item_selected(index):
	pass # Replace with function body.


func _on_preset_h_slider_value_changed(value):
	# start here https://docs.godotengine.org/en/stable/tutorials/3d/mesh_lod.html
	pass # Replace with function body.


# -- AUDIO TAB --

func _on_general_h_scroll_bar_value_changed(value):
	Audio.x = value


func _on_music_h_scroll_bar_value_changed(value):
	Audio.y = value


func _on_sfx_h_scroll_bar_value_changed(value):
	Audio.z = value


# -- Save and Exit buttons

func _on_return_button_pressed():
	MainContainer.visible = true
	OptionContainer.visible = false


func _on_apply_button_pressed():
	MainContainer.visible = true
	OptionContainer.visible = false
	_save_settings()



#func _on_vsync_option_button_item_selected(index):
	## check the documentation about Vsync : https://docs.godotengine.org/en/stable/classes/class_displayserver.html#enum-displayserver-vsyncmode
	#Vsync = index
