extends CanvasLayer

var minimum_value = -80

func _ready():
	$ColorRect.hide()
	$ColorRect/Fullscreen.pressed = true
	_on_Fullscreen_toggled(true)

func show_self():
	$ColorRect.show()

func _on_Resume_pressed():
	$ColorRect.hide()

func _on_Quit_pressed():
	get_tree().quit()

func _on_MusicControl_value_changed(value):
	if value <= minimum_value:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
	AudioServer.set_bus_volume_db(0, lerp(AudioServer.get_bus_volume_db(0), value, 1.0))


func _on_RestartLevel_pressed():
	get_tree().reload_current_scene()


func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = true


func _on_Windowed_toggled(button_pressed):
	OS.window_fullscreen = false


func _on_ToolButton_pressed():
	$Popup.hide()


func _on_LearnButton_pressed():
	$Popup.show()


func _on_NextLevel_pressed():
	Globals.next_level()
