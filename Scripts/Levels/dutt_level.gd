class_name GameLevel
extends Node3D

@export var player_default_spawn_position = Vector3(4.194, 0.172, 6.712)

func _ready() -> void:
	GlobalInGame.level = self
	GlobalInGame.level_ready.emit()

func pause_game():
	pass
