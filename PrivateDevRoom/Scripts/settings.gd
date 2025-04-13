extends ColorRect

@onready var Master_Bus = AudioServer.get_bus_index("Master")
@onready var SFX_Bus = AudioServer.get_bus_index("SFX")
@onready var Music_Bus = AudioServer.get_bus_index("Music")
@onready var main_slider: HSlider = %MainSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var music_slider: HSlider = %MusicSlider

func _ready() -> void:
	main_slider.value = db_to_linear(AudioServer.get_bus_volume_db(Master_Bus))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_Bus))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(Music_Bus))

func _on_main_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(Master_Bus, linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_Bus, linear_to_db(value))

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(Music_Bus, linear_to_db(value))

func _on_close_button_pressed() -> void:
	self.queue_free()
