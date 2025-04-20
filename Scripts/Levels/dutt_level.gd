extends Node3D

var player_default_spawn_position = Vector3(4.194, 0.172, 6.712)

func _ready() -> void:
	GlobalInGame.level = self

func pause_game():
	pass


func _on_h_slider_value_changed(value: float) -> void:
	GlobalInGame.set_NPC_animation_speed(value)
	print(value)
