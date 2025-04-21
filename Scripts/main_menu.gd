extends Control

var busy : bool = false

func _ready() -> void:
	AudioServer.set_bus_mute(1, true)
	GlobalAudioPlayer.play_music("Menu")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_pressed() -> void:
	if busy: return
	busy = true
	GlobalSceneTransition.start_level("DuttLevel")

func _on_settings_pressed() -> void:
	var settings_window : Control = load(Global.SCENES_DICTIONARY.Settings).instantiate()
	add_child(settings_window)

func _on_exit_pressed() -> void:
	if busy: return
	busy = true 
	get_tree().quit()
