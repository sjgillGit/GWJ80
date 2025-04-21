extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_handle_pause()


func _handle_pause():
	if visible:
		_unpause()
	else:
		_pause()

		
func _pause():
	show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unpause():
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_resume_button_pressed() -> void:
	_handle_pause()
	


func _on_settings_button_pressed() -> void:
	var settings_window = load(Global.SCENES_DICTIONARY["Settings"]).instantiate()
	add_child(settings_window)


func _on_menu_button_pressed() -> void:
	_unpause()
	GlobalSceneTransition.change_scene(Global.SCENES_DICTIONARY["MainMenu"])
