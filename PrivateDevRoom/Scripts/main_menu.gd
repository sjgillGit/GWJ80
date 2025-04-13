extends Control

@export var game_scene : PackedScene
@export var settings_scene : PackedScene

func _on_start_pressed() -> void:
	# Load main scene with Global Transition
	pass # Replace with function body.

func _on_settings_pressed() -> void:
	if settings_scene:
		var scene = settings_scene.instantiate()
		add_child(scene)
	else:
		printerr("Settings scene not found")

func _on_exit_pressed() -> void:
	get_tree().quit()
