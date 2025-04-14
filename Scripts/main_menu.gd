extends Control

func _on_start_pressed() -> void:
	# Load main scene with Global Transition
	pass # Replace with function body.

#func _on_settings_pressed() -> void:
	#var settings_scene : PackedScene = load(Global.SCENES_DICTIONARY.MainMenu)
	#settings_scene.instantiate()
	#add_child(settings_scene)

func _on_exit_pressed() -> void:
	get_tree().quit()
