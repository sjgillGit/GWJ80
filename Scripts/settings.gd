extends Control

@onready var Master_Bus = AudioServer.get_bus_index("Master")
@onready var SFX_Bus = AudioServer.get_bus_index("SFX")
@onready var Music_Bus = AudioServer.get_bus_index("Music")
@onready var main_slider: HSlider = %MainSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var music_slider: HSlider = %MusicSlider

@onready var resolution_options : OptionButton = %ResolutionOption
@onready var screen_mode_options : OptionButton = %ScreenModeOption

const RESOLUTION_SETTINGS : Dictionary[String, Vector2i] = {
	"480p" : Vector2i(854 , 480) ,
	"720p" : Vector2i(1280 , 720) ,
	"900p" : Vector2i(1600 , 900) ,
	"1080p" : Vector2i(1920, 1080) ,
	"UW 1080p" : Vector2i(2560 , 1080) , 
	"1440p" : Vector2i(2560, 1440) ,
	"2160p" : Vector2i(3840, 2160)
}

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

func _on_resolution_option_item_selected(index: int) -> void:
	DisplayServer.window_set_size(
		RESOLUTION_SETTINGS[resolution_options.get_item_text(index)]
	)

func _on_screen_mode_option_item_selected(index: int) -> void:
	match screen_mode_options.get_item_text(index):
		"Windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			get_window().borderless = false
		"FullScreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			get_window().borderless = false
		"Borderless Window":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			get_window().borderless = true
		"Borderless FullScreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			get_window().borderless = true

func _on_close_button_pressed() -> void:
	self.queue_free()
