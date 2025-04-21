extends Control

func _ready() -> void:
	GlobalAudioPlayer.play_music("Menu")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_pressed() -> void:
	GlobalSceneTransition.start_level("DuttLevel")

func _on_settings_pressed() -> void:
	var settings_window : Control = load(Global.SCENES_DICTIONARY.Settings).instantiate()
	add_child(settings_window)

func _on_exit_pressed() -> void:
	get_tree().quit()
