extends CanvasLayer

@export var fade_in_time : float = 1.0
@export var fade_out_time : float = 1.0
@export_group("Internal connections")
@export var fading_texture : ColorRect

func _process(delta: float) -> void:
	print(fading_texture.self_modulate)

func change_scene(new_scene_path : String):
	await fade_in()
	get_tree().change_scene_to_file(new_scene_path)
	await fade_out()

func fade_in():
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(fading_texture, "self_modulate:a" , 1.0 , fade_in_time)
	await tween.finished

func fade_out():
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(fading_texture, "self_modulate:a" , 0.0, fade_out_time)
	await tween.finished
	

func start_level(level_name : String) -> void:
	await fade_in()
	var level = load(Global.LEVELS_DICTIONARY[level_name])
	get_tree().change_scene_to_packed(level)
	await GlobalInGame.level_ready
	fade_out()
