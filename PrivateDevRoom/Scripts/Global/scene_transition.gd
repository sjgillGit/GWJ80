extends CanvasLayer

@export var fade_in_time : float = 1.0
@export var fade_out_time : float = 1.0
@export_group("Internal connections")
@export var fading_texture : ColorRect

func change_scene(new_scene_path : String):
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(fading_texture, "self_modulate" , Color(255, 255 , 255 , 0), fade_in_time)
	await tween.finished
	get_tree().change_scene_to_file(new_scene_path)
	tween.tween_property(fading_texture, "self_modulate" , Color(255, 255 , 255 , 255), fade_out_time)
